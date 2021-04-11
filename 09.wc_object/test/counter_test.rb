# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/counter'

module Wc
  class CounterTest < Test::Unit::TestCase
    test 'count' do
      hello_world = read_file('fixtures/hello_world.md')
      lorem_ipsum = read_file('fixtures/lorem_ipsum.txt')
      counter = Counter.new(%i[lines words bytes])
      assert_equal [3, 3, 29],   counter.count(hello_world)
      assert_equal [3, 19, 124], counter.count(lorem_ipsum)
      assert_equal [6, 22, 153], counter.total_counts
    end

    private

    def read_file(path)
      full_path = File.expand_path(path, __dir__)
      File.read(full_path)
    end
  end
end
