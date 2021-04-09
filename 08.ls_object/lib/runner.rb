# frozen_string_literal: true

require_relative './file_collector'
require_relative './file_list'
require_relative './script_options'

module Ls
  module Runner
    def self.run(argv: ARGV, stdout: $stdout, stderr: $stderr, width: 80)
      options = Ls::ScriptOptions.new.parse(argv)

      options.error_paths.each do |path|
        stderr.puts "ls: #{path}: No such file or directory"
      end

      groups = []

      groups << FileList.new(options.file_paths).render(width: width) unless options.file_paths.empty?

      need_label = !options.file_paths.empty? || options.dir_paths.size >= 2

      options.dir_paths.map do |path|
        label = need_label ? "#{path}:\n" : ''
        files = FileCollector.collect(path, all: options.all, reverse: options.reverse)
        file_list = FileList.new(files)
        groups << label + file_list.render(width: width)
      end

      stdout.print groups.join("\n")
    end
  end
end
