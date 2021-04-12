# frozen_string_literal: true

require_relative './shot'
require_relative './frame'
require_relative './last_frame'

module Bowling
  class Game
    def initialize(marks)
      shots = marks.split(',').map do |mark|
        Shot.new(mark)
      end

      @frames = []
      add_frame(shots) until shots.empty?
    end

    def score
      @frames.sum(&:score)
    end

    private

    def add_frame(shots)
      @frames <<
        if @frames.size < 9
          Frame.new(shots)
        else
          LastFrame.new(shots)
        end
    end
  end
end
