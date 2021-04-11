# frozen_string_literal: true

module Wc
  module CountList
    def self.render(counts, path = nil)
      count_list = counts.map do |count|
        width = [count.to_s.size + 1, 8].max
        format('%*d', width, count)
      end.join

      count_list.prepend(' ') unless count_list.start_with?(' ')

      count_list + (path ? " #{path}" : '')
    end
  end
end
