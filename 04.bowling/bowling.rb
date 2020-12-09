#!/usr/bin/env ruby
# frozen_string_literal: true

module Bowling
end

class << Bowling
  def calculate_score_text(score_text)
    scores = parse_score_text(score_text)
    calculate_score(scores)
  end

  def parse_score_text(score_text)
    score_text.chars.map do |score|
      score == 'X' ? 10 : score.to_i
    end
  end

  def calculate_score(scores)
    frame_scores = []
    i = 0
    while i < scores.size && frame_scores.size < 10
      if scores[i] == 10 # strike
        score = scores[i] + scores[i + 1] + scores[i + 2]
        i += 1
      else
        score = scores[i] + scores[i + 1]
        score += scores[i + 2] if score == 10 # spare
        i += 2
      end
      frame_scores << score
    end
    frame_scores.sum
  end
end

if $PROGRAM_NAME == __FILE__
  if ARGV.empty?
    puts 'usage: ./bowling.rb score_text'
    exit(false)
  end
  scores_text = ARGV[0]
  score = Bowling.calculate_score_text(scores_text)
  puts score
end
