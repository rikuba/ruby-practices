# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/script_options'

module Ls
  class ScriptOptionsTest < Test::Unit::TestCase
    setup do
      project_root = File.expand_path('../..', __dir__)
      @options = ScriptOptions.new(base: project_root)
    end

    test 'parse empty argv' do
      @options.parse([])

      assert_equal [], @options.file_paths
      assert_equal ['.'], @options.dir_paths
      assert_equal [], @options.error_paths
      assert_equal false, @options.all
      assert_equal false, @options.reverse
    end

    test 'parse paths and all option' do
      @options.parse(['01.fizzbuzz', '-a', 'README.md'])

      assert_equal ['README.md'], @options.file_paths
      assert_equal ['01.fizzbuzz'], @options.dir_paths
      assert_equal [], @options.error_paths
      assert_equal true, @options.all
      assert_equal false, @options.reverse
    end

    test 'parse non-existence paths and reverse option' do
      @options.parse(['00.not_found', '-r'])

      assert_equal [], @options.file_paths
      assert_equal [], @options.dir_paths
      assert_equal ['00.not_found'], @options.error_paths
      assert_equal false, @options.all
      assert_equal true, @options.reverse
    end
  end
end
