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
    total = @shots.sum(&:score)
    total += @shots.last.next.score if strike? || spare?
    total += @shots.last.next.next.score if strike?
    total
  end

  def done?
    strike? || @shots.size == 2
  end

  def strike?
    @shots.first.score == 10
  end

  def spare?
    !strike? && @shots[0..1].sum(&:score) == 10
  end
end
