# frozen_string_literal: true

require_relative './text_utils'

module Wc
  class Counter
    attr_reader :total_counts

    def initialize(count_types)
      @count_methods = count_types.map do |type|
        TextUtils.method(type)
      end

      @total_counts = [0] * count_types.size
    end

    def count(text)
      counts = @count_methods.map do |count_method|
        count_method.call(text)
      end

      counts.each_with_index do |count, i|
        @total_counts[i] += count
      end

      counts
    end
  end
end
