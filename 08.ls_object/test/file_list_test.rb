# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/file_list'

module Ls
  class FileListTest < Test::Unit::TestCase
    setup do
      files = %w[
        Gemfile Gemfile.lock README.md Rakefile app babel.config.js bin config
        config.ru db lib log node_modules package.json postcss.config.js
        public storage test tmp vendor yarn.lock
      ]
      @file_list = FileList.new(files)
    end

    test 'should format 3 columns' do
      expected = <<~EXPECTED
        Gemfile           config            postcss.config.js
        Gemfile.lock      config.ru         public
        README.md         db                storage
        Rakefile          lib               test
        app               log               tmp
        babel.config.js   node_modules      vendor
        bin               package.json      yarn.lock
      EXPECTED

      assert_equal expected, @file_list.render(width: 54)
      assert_equal expected, @file_list.render(width: 71)
    end

    test 'should format 4 columns' do
      expected = <<~EXPECTED
        Gemfile           bin               node_modules      tmp
        Gemfile.lock      config            package.json      vendor
        README.md         config.ru         postcss.config.js yarn.lock
        Rakefile          db                public
        app               lib               storage
        babel.config.js   log               test
      EXPECTED

      assert_equal expected, @file_list.render(width: 72)
      assert_equal expected, @file_list.render(width: 89)
    end

    test 'should format 5 columns' do
      expected = <<~EXPECTED
        Gemfile           babel.config.js   lib               public            yarn.lock
        Gemfile.lock      bin               log               storage
        README.md         config            node_modules      test
        Rakefile          config.ru         package.json      tmp
        app               db                postcss.config.js vendor
      EXPECTED

      assert_equal expected, @file_list.render(width: 90)
      assert_equal expected, @file_list.render(width: 107)
    end

    test 'should format 1 column' do
      expected = <<~EXPECTED
        Gemfile
        Gemfile.lock
        README.md
        Rakefile
        app
        babel.config.js
        bin
        config
        config.ru
        db
        lib
        log
        node_modules
        package.json
        postcss.config.js
        public
        storage
        test
        tmp
        vendor
        yarn.lock
      EXPECTED

      assert_equal expected, @file_list.render(width: 1)
      assert_equal expected, @file_list.render(width: 35)
    end
  end
end
