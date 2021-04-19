# frozen_string_literal: true

require_relative './text_utils'

module Wc
  class Counter
    def initialize(count_types)
      @count_types = count_types
    end

    def count(text)
      @count_types.to_h do |type|
        [type, count_content(type, text)]
      end
    end

    private

    def count_content(type, text)
      case type
      when :bytes
        TextUtils.bytes(text)
      when :lines
        TextUtils.lines(text)
      when :chars
        TextUtils.chars(text)
      when :words
        TextUtils.words(text)
      end
    end
  end
end
