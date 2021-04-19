# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/script_options'

module Wc
  class ScriptOptionsTest < Test::Unit::TestCase
    test 'parse empty argv' do
      options = ScriptOptions.new([])

      assert_equal [], options.paths
      assert_equal %i[lines words bytes], options.count_types
    end

    test 'parse one path' do
      options = ScriptOptions.new(['README.md'])

      assert_equal ['README.md'], options.paths
      assert_equal %i[lines words bytes], options.count_types
    end

    test 'parse all options' do
      options = ScriptOptions.new(['-c', '-lm', '-w'])

      assert_equal [], options.paths
      assert_equal %i[lines words chars bytes], options.count_types
    end

    test 'parse paths and one option' do
      options = ScriptOptions.new(['-w', 'README.md', '06.wc/wc.rb'])

      assert_equal ['README.md', '06.wc/wc.rb'], options.paths
      assert_equal %i[words], options.count_types
    end
  end
end
