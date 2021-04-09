# frozen_string_literal: true

require_relative './file_entry'

module Ls
  module FileCollector
    def self.collect(dir, all: false, reverse: false)
      flags = all ? File::FNM_DOTMATCH : 0
      file_names = Dir.glob('*', flags, base: dir)
      file_names.reverse! if reverse
      file_names.map do |name|
        FileEntry.new(name, base: dir)
      end
    end
  end
end
