# frozen_string_literal: true

module Bowling
  class Frame
    def initialize(shots)
      @shots = []
      (@shots << shots.shift) until shots.empty? || done?

      @bonus_shots = shots.take(bonus_count)
    end

    def score
      (@shots + @bonus_shots).sum(&:score)
    end

    private

    def done?
      strike? || @shots.size == 2
    end

    def strike?
      @shots.first&.score == 10
    end

    def spare?
      !strike? && @shots.sum(&:score) == 10
    end

    def bonus_count
      if strike?
        2
      elsif spare?
        1
      else
        0
      end
    end
  end
end
