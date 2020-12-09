# frozen_string_literal: true

require 'minitest/autorun'
require './bowling'

class BowlingTest < Minitest::Test
  def test_calculate_score_text1
    score = Bowling.calculate_score_text('6390038273X9180X645')
    assert_equal 139, score
  end

  def test_calculate_score_text2
    score = Bowling.calculate_score_text('6390038273X9180XXXX')
    assert_equal 164, score
  end

  def test_calculate_score_text3
    score = Bowling.calculate_score_text('0X150000XXX518104')
    assert_equal 107, score
  end
end
