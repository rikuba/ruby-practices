# frozen_string_literal: true

require_relative './file_collector'
require_relative './file_list'

module Ls
  module Runner
    def self.run(paths, width: 80, all: false, reverse: false)
      files = FileCollector.collect(paths[0], all: all, reverse: reverse)
      file_list = FileList.new(files)
      file_list.render(width: width)
    end
  end
end
