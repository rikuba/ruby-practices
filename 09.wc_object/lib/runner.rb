# frozen_string_literal: true

require_relative './counter'
require_relative './count_list'
require_relative './script_options'

module Wc
  class Runner
    attr_reader :status

    def initialize(base: Dir.getwd, stdin: $stdin, stdout: $stdout, stderr: $stderr)
      @base = base
      @stdin  = stdin
      @stdout = stdout
      @stderr = stderr
      @status = 0
    end

    def run(argv)
      options = ScriptOptions.new.parse(argv)
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
      paths.filter_map do |path|
        begin
          full_path = File.expand_path(path, @base)
          [path, File.read(full_path)]
        rescue SystemCallError => e
          @status = 1
          @stderr.puts "wc: #{path}: #{e.message.sub(/ @ .*\Z/, '')}"
        end
      end.to_h
    end
  end
end
