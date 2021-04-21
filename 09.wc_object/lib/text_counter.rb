# frozen_string_literal: true

module Wc
  class TextCounter
    WORD_REGEXP = /[[:^space:]]+/.freeze

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
        text.bytesize
      when :lines
        text.count("\n")
      when :chars
        text.size
      when :words
        text.scan(WORD_REGEXP).size
      end
    end
  end
end
