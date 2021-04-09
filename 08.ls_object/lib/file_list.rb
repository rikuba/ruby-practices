# frozen_string_literal: true

module Ls
  class FileList
    def initialize(files)
      @files = files
    end

    def render(params)
      column_width = @files.map(&:size).max + 1
      num_columns = (params[:width] / column_width).clamp(1..nil)
      num_rows = (@files.size / num_columns.to_f).ceil

      columns = @files.each_slice(num_rows).to_a
      rows = transpose(columns)

      rows.map do |row|
        row.map do |text|
          text&.ljust(column_width)
        end.join.rstrip << "\n"
      end.join
    end

    private

    def transpose(array)
      array[0].zip(*array[1..-1])
    end
  end
end
