# frozen_string_literal: true

module Wc
  module CountList
    def self.render(counts, label = nil)
      count_text = counts.each_value.map do |count|
        width = [count.to_s.size + 1, 8].max
        format('%*d', width, count)
      end.join

      count_text.prepend(' ') unless count_text.start_with?(' ')

      count_text + (label ? " #{label}" : '')
    end
  end
end
