# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/text_utils'

module Wc
  class TextUtilsTest < Test::Unit::TestCase
    test 'count simple text' do
      text = 'Hello World!'

      assert_equal 0,  TextUtils.lines(text)
      assert_equal 2,  TextUtils.words(text)
      assert_equal 12, TextUtils.chars(text)
      assert_equal 12, TextUtils.bytes(text)
    end

    test 'count japanese text' do
      text = 'こんにちは世界!'

      assert_equal 0,  TextUtils.lines(text)
      assert_equal 1,  TextUtils.words(text)
      assert_equal 8,  TextUtils.chars(text)
      assert_equal 22, TextUtils.bytes(text)
    end

    test 'count lorem ipsum' do
      path = File.expand_path('fixtures/lorem_ipsum.txt', __dir__)
      text = File.read(path)

      assert_equal 3,   TextUtils.lines(text)
      assert_equal 19,  TextUtils.words(text)
      assert_equal 124, TextUtils.chars(text)
      assert_equal 124, TextUtils.bytes(text)
    end
  end
end
