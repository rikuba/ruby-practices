# frozen_string_literal: true

require_relative './frame'

class LastFrame < Frame
  def score
    @shots.sum(&:score)
  end

  def done?
    @shots.size == (strike? || spare? ? 3 : 2)
  end
end
