#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/runner'

if $PROGRAM_NAME == __FILE__
  runner = Wc::Runner.new
  runner.run(ARGV)
  exit(runner.status)
end
