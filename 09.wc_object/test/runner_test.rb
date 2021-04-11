# frozen_string_literal: true

require 'stringio'
require 'test/unit'
require_relative '../lib/runner'

module Wc
  class RunnerTest < Test::Unit::TestCase
    setup do
      @stdin  = StringIO.new
      @stdout = StringIO.new
      @stderr = StringIO.new
      @runner = Runner.new(base: __dir__, stdin: @stdin, stdout: @stdout, stderr: @stderr)
    end

    test 'run with empty argv' do
      @stdin.string = "Hello World!\n"
      @runner.run([])

      assert_equal "       1       2      13\n", @stdout.string
    end

    test 'run with one file argument' do
      @runner.run(%w[fixtures/lorem_ipsum.txt])

      assert_equal "       3      19     124 fixtures/lorem_ipsum.txt\n", @stdout.string
    end

    test 'run with two file arguments' do
      @runner.run(%w[fixtures/lorem_ipsum.txt ./fixtures/hello_world.md])

      assert_equal <<~EXPECTED, @stdout.string
        \       3      19     124 fixtures/lorem_ipsum.txt
        \       3       3      29 ./fixtures/hello_world.md
        \       6      22     153 total
      EXPECTED
    end

    test 'run with one file and -l option' do
      @runner.run(%w[-l fixtures/lorem_ipsum.txt])

      assert_equal "       3 fixtures/lorem_ipsum.txt\n", @stdout.string
    end

    test 'run with one file and -c and -m options' do
      @runner.run(%w[-cm fixtures/hello_world.md])

      assert_equal "      13      29 fixtures/hello_world.md\n", @stdout.string
    end

    test 'run with three files and all options' do
      @runner.run(%w[-clmw fixtures/lorem_ipsum.txt ../.gitkeep fixtures/hello_world.md])

      assert_equal <<~EXPECTED, @stdout.string
        \       3      19     124     124 fixtures/lorem_ipsum.txt
        \       0       0       0       0 ../.gitkeep
        \       3       3      13      29 fixtures/hello_world.md
        \       6      22     137     153 total
      EXPECTED
    end

    test 'run with invalid paths' do
      @runner.run(%w[fixtures/non_existent_fixture ../not_found.md])

      assert_equal "       0       0       0 total\n", @stdout.string
      assert_equal <<~EXPECTED, @stderr.string
        wc: fixtures/non_existent_fixture: No such file or directory
        wc: ../not_found.md: No such file or directory
      EXPECTED
    end
  end
end
