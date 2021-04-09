# frozen_string_literal: true

require_relative './file_entry'
require_relative './file_list'
require_relative './file_table'
require_relative './script_options'

module Ls
  class Runner
    def initialize(base: Dir.getwd, stdout: $stdout, stderr: $stderr, width: 80)
      @base = base
      @stdout = stdout
      @stderr = stderr
      @width = width
    end

    def run(argv)
      options = Ls::ScriptOptions.new(base: @base).parse(argv)
      renderer_class = options.long ? FileTable : FileList

      warn_error_paths(options.error_paths)

      groups = []

      unless options.file_paths.empty?
        files = options.file_paths.map do |path|
          FileEntry.new(path, base: @base)
        end
        renderer = renderer_class.new(files)
        groups << render_files(renderer: renderer, blocks: false)
      end

      label_needed = !options.file_paths.empty? || options.dir_paths.size >= 2

      options.dir_paths.each do |path|
        files = collect_files(path, all: options.all, reverse: options.reverse)
        renderer = renderer_class.new(files)
        groups << render_files(renderer: renderer, blocks: true, path: label_needed && path)
      end

      @stdout.print groups.join("\n")
    end

    private

    def warn_error_paths(error_paths)
      error_paths.each do |path|
        @stderr.puts "ls: #{path}: No such file or directory"
      end
    end

    def render_files(renderer:, blocks:, path: nil)
      label = path ? "#{path}:\n" : ''
      file_list = renderer.render(blocks: blocks, width: @width)
      label + file_list
    end

    def collect_files(dir, all: false, reverse: false)
      base = File.expand_path(dir, @base)
      flags = all ? File::FNM_DOTMATCH : 0
      file_names = Dir.glob('*', flags, base: base)
      file_names.reverse! if reverse
      file_names.map do |name|
        FileEntry.new(name, base: base)
      end
    end
  end
end
