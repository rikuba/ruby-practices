# frozen_string_literal: true

module Wc
  module TextUtils
    WORD_REGEXP = /[[:^space:]]+/.freeze

    def self.bytes(text)
      text.bytesize
    end

    def self.lines(text)
      text.count("\n")
    end

    def self.chars(text)
      text.size
    end

    def self.words(text)
      text.scan(WORD_REGEXP).size
    end
  end
end
