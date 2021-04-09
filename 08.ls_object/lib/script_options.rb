# frozen_string_literal: true

require 'optparse'

module Ls
  class ScriptOptions
    attr_reader :file_paths, :dir_paths, :error_paths, :all, :long, :reverse

    def initialize(base: Dir.getwd)
      @base = base
      @file_paths = []
      @dir_paths = []
      @error_paths = []
      @all = false
      @long = false
      @reverse = false

      @option_parser = OptionParser.new do |parser|
        parser.on('-a') { @all = true }
        parser.on('-l') { @long = true }
        parser.on('-r') { @reverse = true }
      end
    end

    def parse(argv)
      paths = @option_parser.parse(argv)
      paths << '.' if paths.empty?
      paths.each do |path|
        partition_path(path)
      end
      [@file_paths, @dir_paths, @error_paths].each(&:sort!)
      [@file_paths, @dir_paths].each(&:reverse!) if @reverse
      self
    end

    private

    def partition_path(path)
      expanded_path = File.expand_path(path, @base)
      if File.file?(expanded_path)
        @file_paths << path
      elsif File.directory?(expanded_path)
        @dir_paths << path
      else
        @error_paths << path
      end
    end
  end
end
