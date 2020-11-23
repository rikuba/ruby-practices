#!/usr/bin/env ruby

require 'date'
require 'optparse'

WIDTH = 20
WDAY = '日月火水木金土'

def makeCalendar(year, month)
  caption = "#{month}月 #{year}".center(WIDTH)
  header = WDAY.chars.join(' ')
  weeks = []

  first = Date.new(year, month, 1)
  last = Date.new(year, month, -1)
  first.upto(last) do |d|
    # 週の始まり
    weeks.push([]) if d.wday == 0 || d.day == 1

    weeks.last[d.wday] = d.day
  end

  weeks = weeks.map do |week|
    week.map {|day| day.to_s.rjust(2)}.join(' ')
  end

  [caption, header] + weeks
end

params = ARGV.getopts('y:m:')

year = params['y'].to_i
year = Date.today.year if year == 0

month = params['m'].to_i
month = Date.today.month if month == 0

puts makeCalendar(year, month).join("\n")
puts # 空行を出力
