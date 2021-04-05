# frozen_string_literal: true

class Shot
  attr_reader :mark, :prev, :next

  def initialize(mark, prev: nil)
    @mark = mark
    prev&.next = self
    self.prev = prev
  end

  def score
    return 10 if mark == 'X'

    mark.to_i
  end

  protected

  attr_writer :prev, :next
end
