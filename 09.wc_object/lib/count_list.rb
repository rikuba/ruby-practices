# frozen_string_literal: true

module Wc
  module CountList
    COUNT_TYPE_ORDER = %i[lines words chars bytes].freeze

    def self.render(counts, label = nil)
      count_text = COUNT_TYPE_ORDER.filter_map do |count_type|
        next unless counts.key?(count_type)

        count = counts[count_type]
        width = [count.to_s.size + 1, 8].max
        format('%*d', width, count)
      end.join

      count_text + (label ? " #{label}" : '')
    end
  end
end
