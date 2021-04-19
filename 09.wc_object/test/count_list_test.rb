# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/count_list'

module Wc
  class CountListTest < Test::Unit::TestCase
    test 'render big counts' do
      counts = { lines: 12_345_678, words: 123_456_789, chars: 1_234_567_890 }
      result = CountList.render(counts, 'big_file')
      assert_equal ' 12345678 123456789 1234567890 big_file', result
    end
  end
end
