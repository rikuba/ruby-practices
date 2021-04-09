# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/file_collector'

module Ls
  class FileCollectorTest < Test::Unit::TestCase
    test 'collect' do
      dir = File.expand_path('../../05.ls', __dir__)
      filenames = FileCollector.collect(dir)
      assert_equal %w[ls.rb ls_test.rb], filenames
    end

    test 'collect all' do
      dir = File.expand_path('../../05.ls', __dir__)
      filenames = FileCollector.collect(dir, all: true)
      assert_equal %w[. .. .gitkeep ls.rb ls_test.rb], filenames
    end

    test 'collect reversed' do
      dir = File.expand_path('../../05.ls', __dir__)
      filenames = FileCollector.collect(dir, reverse: true)
      assert_equal %w[ls_test.rb ls.rb], filenames
    end

    test 'collect all and reversed' do
      dir = File.expand_path('../../05.ls', __dir__)
      filenames = FileCollector.collect(dir, all: true, reverse: true)
      assert_equal %w[ls_test.rb ls.rb .gitkeep .. .], filenames
    end
  end
end
