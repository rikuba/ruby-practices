# frozen_string_literal: true

require_relative './shot'
require_relative './frame'
require_relative './last_frame'

class Game
  attr_reader :frames

  def initialize
    @frames = Array.new(9) { Frame.new } << LastFrame.new
    @frames.each_cons(2) do |prev_frame, next_frame|
      prev_frame.next = next_frame
    end
  end

  def load_marks(marks)
    marks = marks.split(',') if marks.is_a? String
    shots = Shot.create_sequence(*marks)
    frame = frames.first
    shots.each do |shot|
      frame.mark(shot)
      frame = frame.next if frame.done?
    end
  end

  def score
    @frames.sum(&:score)
  end
end
