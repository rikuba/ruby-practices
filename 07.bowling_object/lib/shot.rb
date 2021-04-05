# frozen_string_literal: true

module Bowling
  def self.create_shots(*marks)
    marks.map { |mark| Shot.new(mark) }.tap do |shots|
      shots.each_cons(2) do |prev_shot, next_shot|
        prev_shot.next = next_shot
      end
    end
  end

  class Shot
    attr_accessor :next
    attr_reader :mark

    def initialize(mark)
      @mark = mark
    end

    def score
      mark == 'X' ? 10 : mark.to_i
    end
  end
end
