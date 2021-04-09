#!/usr/bin/env ruby
# frozen_string_literal: true

require 'io/console/size'
require_relative './lib/runner'
require_relative './lib/script_options'

if $PROGRAM_NAME == __FILE__
  options = Ls::ScriptOptions.new.parse(ARGV)
  *, width = IO.console_size

  print Ls::Runner.run(options.paths, width: width, all: options.all, reverse: options.reverse)
end
