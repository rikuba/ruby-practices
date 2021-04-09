# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/file_collector'

module Ls
  class FileCollectorTest < Test::Unit::TestCase
    test 'collect' do
      dir = File.expand_path('../../05.ls', __dir__)
      file_names = FileCollector.collect(dir).map(&:name)
      assert_equal %w[ls.rb ls_test.rb], file_names
    end

    test 'collect all' do
      dir = File.expand_path('../../05.ls', __dir__)
      file_names = FileCollector.collect(dir, all: true).map(&:name)
      assert_equal %w[. .. .gitkeep ls.rb ls_test.rb], file_names
    end

    test 'collect reversed' do
      dir = File.expand_path('../../05.ls', __dir__)
      file_names = FileCollector.collect(dir, reverse: true).map(&:name)
      assert_equal %w[ls_test.rb ls.rb], file_names
    end

    test 'collect all and reversed' do
      dir = File.expand_path('../../05.ls', __dir__)
      file_names = FileCollector.collect(dir, all: true, reverse: true).map(&:name)
      assert_equal %w[ls_test.rb ls.rb .gitkeep .. .], file_names
    end
  end
end
