# frozen_string_literal: true

require_relative './count_list'
require_relative './script_options'
require_relative './text_counter'

module Wc
  class Runner
    def initialize(base: Dir.getwd, stdin: $stdin, stdout: $stdout)
      @base = base
      @stdin  = stdin
      @stdout = stdout
    end

    def run(argv)
      options = ScriptOptions.new(argv)

      if options.paths.empty?
        run_with_stdin(options)
      else
        run_with_files(options)
      end
    end

    private

    def run_with_stdin(options)
      counter = TextCounter.new(options.count_types)
      input = @stdin.read
      counts = counter.count(input)
      output_counts(counts)
    end

    def run_with_files(options)
      counter = TextCounter.new(options.count_types)

      counts_by_path = options.paths.to_h do |path|
        full_path = File.expand_path(path, @base)
        text = File.read(full_path)
        [path, counter.count(text)]
      end

      counts_by_path.each do |path, counts|
        output_counts(counts, path)
      end

      output_total_counts(counts_by_path.values) if options.paths.size > 1
    end

    def output_counts(counts, label = nil)
      line = CountList.render(counts, label)
      @stdout.puts line
    end

    def output_total_counts(all_counts)
      total_counts = Hash.new(0).merge(*all_counts) do |_key, count1, count2|
        count1 + count2
      end
      output_counts(total_counts, 'total')
    end
  end
end
