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

  test 'linkable' do
    first_shot = Shot.new('8')
    second_shot = Shot.new('2', prev: first_shot)
    assert_nil first_shot.prev
    assert_equal second_shot, first_shot.next
    assert_equal first_shot, second_shot.prev
    assert_nil second_shot.next
  end

  test 'create_sequence' do
    shots = Shot.create_sequence('X', '7', '3')
    assert_instance_of Array, shots
    assert_equal 3, shots.size
    assert_instance_of Shot, shots[0]
    assert_instance_of Shot, shots[1]
    assert_instance_of Shot, shots[2]

    assert_equal 10, shots[0].score
    assert_equal  7, shots[1].score
    assert_equal  3, shots[2].score

    assert_nil shots[0].prev
    assert_equal shots[1], shots[0].next
    assert_equal shots[0], shots[1].prev
    assert_equal shots[2], shots[1].next
    assert_equal shots[1], shots[2].prev
    assert_nil shots[2].next
  end
end
