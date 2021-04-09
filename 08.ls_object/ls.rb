#!/usr/bin/env ruby
# frozen_string_literal: true

require 'io/console/size'
require_relative './lib/runner'
require_relative './lib/script_options'

if $PROGRAM_NAME == __FILE__
  *, width = IO.console_size

  Ls::Runner.run(width: width)
end
