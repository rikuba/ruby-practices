#!/usr/bin/env ruby

require 'date'
require 'optparse'

def makeCalendar(year, month)
  caption = "#{month}月 #{year}".center(20)
  header = '日 月 火 水 木 金 土'
  
  first = Date.new(year, month, 1)
  last = Date.new(year, month, -1)
  spaces = Array.new(first.wday, '')
  days = [*first.day..last.day]
  weeks = (spaces + days).each_slice(7).map do |week|
    week.map {|day| day.to_s.rjust(2)}.join(' ')
  end

  [caption, header] + weeks
end

params = ARGV.getopts('y:m:')

year = params['y']&.to_i || Date.today.year
month = params['m']&.to_i || Date.today.month

puts makeCalendar(year, month)
puts ''
