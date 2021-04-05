# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/game'

class GameTest < Test::Unit::TestCase
  setup do
    @game = Game.new
  end

  test 'score 139' do
    @game.load_marks('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
    assert_equal 139, @game.score
  end

  test 'score 164' do
    @game.load_marks('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
    assert_equal 164, @game.score
  end

  test 'score 107' do
    @game.load_marks('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
    assert_equal 107, @game.score
  end

  test 'score 134' do
    @game.load_marks('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0')
    assert_equal 134, @game.score
  end

  test 'score 0' do
    @game.load_marks('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
    assert_equal 0, @game.score
  end

  test 'perfect game' do
    @game.load_marks('X,X,X,X,X,X,X,X,X,X,X,X')
    assert_equal 300, @game.score
  end
end
