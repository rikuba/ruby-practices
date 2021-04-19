# frozen_string_literal: true

require 'optparse'

module Wc
  class ScriptOptions
    attr_reader :paths

    def initialize(argv)
      @paths = []
      @count_types = []
      parse(argv)
    end

    def count_types
      # always return in this order
      %i[lines words chars bytes] & @count_types
    end

    private

    def parse(argv)
      option_parser = OptionParser.new do |parser|
        parser.on('-c') { @count_types << :bytes }
        parser.on('-l') { @count_types << :lines }
        parser.on('-m') { @count_types << :chars }
        parser.on('-w') { @count_types << :words }
      end

      @paths = option_parser.parse(argv)
      @count_types = %i[lines words bytes] if @count_types.empty?
    end
  end
end
