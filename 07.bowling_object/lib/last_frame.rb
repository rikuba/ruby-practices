# frozen_string_literal: true

require_relative './frame'

module Bowling
  class LastFrame < Frame
    def done?
      @shots.size == (strike? || spare? ? 3 : 2)
    end
  end
end
