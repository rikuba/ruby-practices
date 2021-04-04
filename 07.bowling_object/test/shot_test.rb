# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/shot'

class ShotTest < Test::Unit::TestCase
  test 'when mark is X, score should be 10' do
    assert_equal 10, Shot.new('X').score
  end

  test 'when mark is a number, score should be integer of that number' do
    assert_equal 0, Shot.new('0').score
    assert_equal 9, Shot.new('9').score
  end
end
