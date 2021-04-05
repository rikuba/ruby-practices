# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/frame'
require_relative '../lib/shot'

module Bowling
  class FrameTest < Test::Unit::TestCase
    test 'mark strike' do
      shots = Bowling.create_shots('X', '1', '2', '3')
      frame = Frame.new
      frame.mark(shots[0])
      assert frame.done?
      assert frame.strike?
      assert_equal 10 + 1 + 2, frame.score
    end

    test 'mark spare' do
      shots = Bowling.create_shots('6', '4', '5', '3')
      frame = Frame.new
      frame.mark(shots[0])
      frame.mark(shots[1])
      assert frame.done?
      assert frame.spare?
      assert_equal 6 + 4 + 5, frame.score
    end

    test 'mark open frame' do
      shots = Bowling.create_shots('5', '3', '1', '2')
      frame = Frame.new
      frame.mark(shots[0])
      frame.mark(shots[1])
      assert frame.done?
      assert_false frame.strike?
      assert_false frame.spare?
      assert_equal 5 + 3, frame.score
    end
  end
end
