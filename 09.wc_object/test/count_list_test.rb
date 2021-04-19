# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/count_list'

module Wc
  class CountListTest < Test::Unit::TestCase
    test 'render 3 count values' do
      counts = { lines: 3, words: 19, chars: 124 }
      result = CountList.render(counts)
      assert_equal '       3      19     124', result
    end

    test 'render 3 count values and label' do
      counts = { lines: 3, words: 19, chars: 124 }
      result = CountList.render(counts, 'count_list.rb')
      assert_equal '       3      19     124 count_list.rb', result
    end

    test 'render 4 count values' do
      counts = { lines: 3, words: 19, chars: 124, bytes: 124 }
      result = CountList.render(counts)
      assert_equal '       3      19     124     124', result
    end

    test 'render 1 count values' do
      counts = { lines: 3 }
      result = CountList.render(counts)
      assert_equal '       3', result
    end

    test 'render big counts' do
      counts = { lines: 12_345_678, words: 123_456_789, chars: 1_234_567_890 }
      result = CountList.render(counts, 'big_file')
      assert_equal ' 12345678 123456789 1234567890 big_file', result
    end
  end
end
