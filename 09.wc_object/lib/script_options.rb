# frozen_string_literal: true

require 'optparse'

module Wc
  class ScriptOptions
    attr_reader :count_types, :paths

    def initialize(argv)
      @paths = []
      @count_types = []
      parse(argv)
    end

    private

    def parse(argv)
      option_parser = OptionParser.new do |parser|
        parser.on('-l') { @count_types << :lines }
        parser.on('-w') { @count_types << :words }

        # -c and -m options are exclusive
        parser.on('-c') do
          @count_types.delete(:chars)
          @count_types << :bytes
        end
        parser.on('-m') do
          @count_types.delete(:bytes)
          @count_types << :chars
        end
      end

      @paths = option_parser.parse(argv)
      @count_types = %i[lines words bytes] if @count_types.empty?
    end
  end
end
