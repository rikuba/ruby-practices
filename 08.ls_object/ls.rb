#!/usr/bin/env ruby
# frozen_string_literal: true

require 'io/console/size'
require_relative './lib/runner'

if $PROGRAM_NAME == __FILE__
  _, width = IO.console_size

  runner = Ls::Runner.new(width: width)
  runner.run(ARGV)
end
