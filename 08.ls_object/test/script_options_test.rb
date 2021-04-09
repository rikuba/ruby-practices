# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/script_options'

module Ls
  class ScriptOptionsTest < Test::Unit::TestCase
    setup do
      @options = ScriptOptions.new
    end

    test 'parse empty argv' do
      @options.parse([])

      assert_equal ['.'], @options.paths
      assert_equal false, @options.all
      assert_equal false, @options.reverse
    end

    test 'parse argv' do
      @options.parse(['/usr', '../lib', '-a', '-r'])

      assert_equal ['/usr', '../lib'], @options.paths
      assert_equal true, @options.all
      assert_equal true, @options.reverse
    end
  end
end
