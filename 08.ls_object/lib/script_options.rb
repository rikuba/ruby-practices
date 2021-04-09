# frozen_string_literal: true

require 'optparse'

module Ls
  class ScriptOptions
    attr_reader :file_paths, :dir_paths, :error_paths, :all, :reverse

    def initialize(base: Dir.getwd)
      @base = base
      @file_paths = []
      @dir_paths = []
      @error_paths = []
      @all = false
      @reverse = false

      @option_parser = OptionParser.new do |parser|
        parser.on('-a') { @all = true }
        parser.on('-r') { @reverse = true }
      end
    end

    def parse(argv)
      paths = @option_parser.parse(argv)
      paths << '.' if paths.empty?
      paths.each do |path|
        expanded_path = File.expand_path(path, @base)
        if File.file?(expanded_path)
          @file_paths << path
        elsif File.directory?(expanded_path)
          @dir_paths << path
        else
          @error_paths << path
        end
      end
      [@file_paths, @dir_paths, @error_paths].map(&:sort!)
      self
    end
  end
end
