#!/usr/bin/env ruby

(1..100).each do |num|
  puts case 0
  when num % 15
    'FizzBuzz'
  when num % 3
    'Fizz'
  when num % 5
    'Buzz'
  else
    num
  end
end
