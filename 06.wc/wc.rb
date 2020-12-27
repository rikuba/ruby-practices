#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WORD_REGEXP = /[[:^space:]]+/.freeze

COUNTERS = {
  bytes: proc { |text| text.bytesize },
  lines: proc { |text| text.count("\n") },
  chars: proc { |text| text.size },
  words: proc { |text| text.scan(WORD_REGEXP).size }
}.freeze

def count_contents(text, counters)
  counters.map do |counter|
    COUNTERS[counter].call(text)
  end
end

def format_counts(counts, label = nil)
  line = counts.map do |count|
    width = [count.to_s.size + 1, 8].max
    format('%*d', width, count)
  end.join
  line << " #{label}" unless label.nil?
  line
end

def parse_argv(argv)
  counters = []

  opt = OptionParser.new
  opt.on('-c') { counters << :bytes }
  opt.on('-l') { counters << :lines }
  opt.on('-m') { counters << :chars }
  opt.on('-w') { counters << :words }

  paths = opt.parse(argv)
  counters = %i[lines words bytes] if counters.empty?

  [paths, counters]
end

if $PROGRAM_NAME == __FILE__
  paths, counters = parse_argv(ARGV)

  if paths.empty?
    counts = count_contents($stdin.read, counters)
    puts format_counts(counts)
  else
    total_counts = [0] * counters.size
    has_error = false

    paths.each do |path|
      begin
        fail_method = 'open'
        text = File.open(path) do |file|
          fail_method = 'read'
          file.read
        end
      rescue SystemCallError => e
        warn "wc: #{path}: #{fail_method}: #{e.message.sub(/ @ .*\Z/, '')}"
        has_error = true
        next
      end

      counts = count_contents(text, counters)
      puts format_counts(counts, path)
      counts.each_with_index { |count, i| total_counts[i] += count }
    end

    puts format_counts(total_counts, 'total') if paths.size > 1
    abort if has_error
  end
end
