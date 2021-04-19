# frozen_string_literal: true

require_relative './counter'
require_relative './count_list'
require_relative './script_options'

module Wc
  class Runner
    def initialize(base: Dir.getwd, stdin: $stdin, stdout: $stdout)
      @base = base
      @stdin  = stdin
      @stdout = stdout
    end

    def run(argv)
      options = ScriptOptions.new(argv)
      counter = Counter.new(options.count_types)

      if options.paths.empty?
        input = @stdin.read
        counts = counter.count(input)
        output_counts(counts)
      else
        texts = read_files(options.paths)

        texts.each do |path, text|
          counts = counter.count(text)
          output_counts(counts, path)
        end

        output_counts(counter.total_counts, 'total') if options.paths.size > 1
      end
    end

    private

    def output_counts(counts, path = nil)
      line = CountList.render(counts, path)
      @stdout.puts line
    end

    def read_files(paths)
      paths.to_h do |path|
        full_path = File.expand_path(path, @base)
        [path, File.read(full_path)]
      end
    end
  end
end
