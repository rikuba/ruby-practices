#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/game'

if $PROGRAM_NAME == __FILE__
  marks = ARGV.first
  unless marks
    warn 'Usage: ./bowling.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    abort
  end

  game = Bowling::Game.new(marks)
  puts game.score
end
