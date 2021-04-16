# frozen_string_literal: true

module Ls
  class FileList
    def initialize(files)
      @file_names = files.map(&:name)
    end

    def render(params)
      column_width = @file_names.map(&:size).max + 1
      num_columns = [params[:width] / column_width, 1].max
      num_rows = (@file_names.size / num_columns.to_f).ceil

      columns = @file_names.each_slice(num_rows).to_a
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
