# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize
    @shots = []
  end

  def mark(shot)
    @shots << shot
  end

  def score
    @shots.sum(&:score)
  end

  def done?
    strike? || @shots.size == 2
  end

  def strike?
    @shots[0].score == 10
  end

  def spare?
    !strike? && score == 10
  end
end
