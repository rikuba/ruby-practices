# frozen_string_literal: true

module Ls
  module FileCollector
    def self.collect(dir, all: false, reverse: false)
      flags = all ? File::FNM_DOTMATCH : 0
      Dir.glob('*', flags, base: dir).tap do |filenames|
        filenames.reverse! if reverse
      end
    end
  end
end
