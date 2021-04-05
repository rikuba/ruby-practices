# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/last_frame'
require_relative '../lib/shot'

module Bowling
  class LastFrameTest < Test::Unit::TestCase
    test 'mark strike' do
      shots = Bowling.create_shots('X', '4', '3')
      frame = LastFrame.new
      frame.mark(shots[0])
      frame.mark(shots[1])
      frame.mark(shots[2])
      assert frame.done?
      assert frame.strike?
      assert_equal 10 + 4 + 3, frame.score
    end

    test 'mark strike out' do
      shots = Bowling.create_shots('X', 'X', 'X')
      frame = LastFrame.new
      frame.mark(shots[0])
      frame.mark(shots[1])
      frame.mark(shots[2])
      assert frame.done?
      assert frame.strike?
      assert_equal 10 + 10 + 10, frame.score
    end

    test 'mark spare' do
      shots = Bowling.create_shots('5', '5', '2')
      frame = LastFrame.new
      frame.mark(shots[0])
      frame.mark(shots[1])
      frame.mark(shots[2])
      assert frame.done?
      assert frame.spare?
      assert_equal 5 + 5 + 2, frame.score
    end

    test 'mark open frame' do
      shots = Bowling.create_shots('7', '1')
      frame = LastFrame.new
      frame.mark(shots[0])
      frame.mark(shots[1])
      assert frame.done?
      assert_false frame.strike?
      assert_false frame.spare?
      assert_equal 7 + 1, frame.score
    end
  end
end
