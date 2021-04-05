# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/frame'
require_relative '../lib/shot'

class FrameTest < Test::Unit::TestCase
  test 'mark strike' do
    frame = Frame.new
    frame.mark(Shot.new('X'))
    assert frame.done?
    assert frame.strike?
    assert_equal 10, frame.score
  end

  test 'mark spare' do
    frame = Frame.new
    frame.mark(Shot.new('6'))
    frame.mark(Shot.new('4'))
    assert frame.done?
    assert frame.spare?
    assert_equal 10, frame.score
  end

  test 'mark open frame' do
    frame = Frame.new
    frame.mark(Shot.new('5'))
    frame.mark(Shot.new('3'))
    assert frame.done?
    assert_false frame.strike?
    assert_false frame.spare?
    assert_equal 8, frame.score
  end
end
