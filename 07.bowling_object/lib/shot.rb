# frozen_string_literal: true

module Bowling
  class Shot
    attr_accessor :next
    attr_reader :mark

    def self.create_sequence(*marks)
      shots = marks.map { |mark| Shot.new(mark) }
      shots.each_cons(2) do |prev_shot, next_shot|
        prev_shot.next = next_shot
      end
      shots
    end

    def initialize(mark)
      @mark = mark
    end

    def score
      mark == 'X' ? 10 : mark.to_i
    end
  end
end
