# frozen_string_literal: true

require 'optparse'

module Ls
  class ScriptOptions
    attr_reader :all, :paths, :reverse

    def initialize
      @paths = []
      @all = false
      @reverse = false

      @option_parser = OptionParser.new do |parser|
        parser.on('-a') { @all = true }
        parser.on('-r') { @reverse = true }
      end
    end

    def parse(argv)
      @paths = @option_parser.parse(argv)
      @paths << '.' if @paths.empty?
      self
    end
  end
end
