# frozen_string_literal: true

require 'io/console/size'
require 'stringio'
require 'test/unit'
require_relative '../lib/runner'

module Ls
  class RunnerTest < Test::Unit::TestCase
    setup do
      @base = File.expand_path('../..', __dir__)
      @stdout = StringIO.new
      @stderr = StringIO.new
      *, @width = IO.console_size
    end

    def self.ls(*argv)
      define_method("test ls #{argv.join(' ')}") do
        expected = Dir.chdir(@base) { `ls #{argv.join(' ')}` }
        runner = Runner.new(base: @base, stdout: @stdout, stderr: @stderr)
        runner.run(argv)
        assert_equal expected, @stdout.string
      end
    end

    private_class_method :ls

    ls '-l'

    ls '-lr'

    ls '-l', '05.ls'

    ls '-lr', '.gitignore', '.', 'README.md', '05.ls'
  end
end
