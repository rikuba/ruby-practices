# frozen_string_literal: true

require 'stringio'
require 'test/unit'
require_relative '../lib/runner'

module Wc
  class RunnerTest < Test::Unit::TestCase
    setup do
      @stdin  = StringIO.new
      @stdout = StringIO.new
      @runner = Runner.new(base: __dir__, stdin: @stdin, stdout: @stdout)
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

    test 'run with three files and -c and -l options' do
      @runner.run(%w[-cl fixtures/lorem_ipsum.txt ../.gitkeep fixtures/hello_world.md])

      assert_equal <<~EXPECTED, @stdout.string
        \       3     124 fixtures/lorem_ipsum.txt
        \       0       0 ../.gitkeep
        \       3      29 fixtures/hello_world.md
        \       6     153 total
      EXPECTED
    end

    test 'options should always be sorted in the same order' do
      @runner.run(%w[-lmw fixtures/lorem_ipsum.txt])
      @runner.run(%w[-cwl fixtures/lorem_ipsum.txt])
      @runner.run(%w[-wlm fixtures/lorem_ipsum.txt])

      assert_equal <<~EXPECTED, @stdout.string
        \       3      19     124 fixtures/lorem_ipsum.txt
        \       3      19     124 fixtures/lorem_ipsum.txt
        \       3      19     124 fixtures/lorem_ipsum.txt
      EXPECTED
    end

    test 'should enable -c when -c is specified after -m' do
      @runner.run(%w[-mc fixtures/hello_world.md])

      assert_equal "      29 fixtures/hello_world.md\n", @stdout.string
    end

    test 'should enable -m when -m is specified after -c' do
      @runner.run(%w[-cm fixtures/hello_world.md])

      assert_equal "      13 fixtures/hello_world.md\n", @stdout.string
    end
  end
end
