# frozen_string_literal: true

module Ls
  class FileEntry
    attr_reader :name

    def initialize(name, base: Dir.getwd, stat: nil)
      @base = base
      @name = name
      @stat = stat
    end

    def stat
      @stat ||= begin
        path = File.expand_path(@name, @base)
        File.lstat(path)
      end
    end
  end
end
