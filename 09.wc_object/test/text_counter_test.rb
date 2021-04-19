# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/text_counter'

module Wc
  class TextCounterTest < Test::Unit::TestCase
    test 'count' do
      hello_world = read_file('fixtures/hello_world.md')
      lorem_ipsum = read_file('fixtures/lorem_ipsum.txt')
      counter = TextCounter.new(%i[lines words bytes])
      assert_equal({ lines: 3, words: 3,  bytes: 29  }, counter.count(hello_world))
      assert_equal({ lines: 3, words: 19, bytes: 124 }, counter.count(lorem_ipsum))
    end

    private

    def read_file(path)
      full_path = File.expand_path(path, __dir__)
      File.read(full_path)
    end
  end
end
