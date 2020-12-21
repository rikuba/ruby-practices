#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

TAB_SIZE = 8
MAX_COLUMNS = 3

def list_directory_contents(all: false)
  filenames = Dir.glob('*', all ? File::FNM_DOTMATCH : 0).sort
  print format_as_multi_column(filenames)
end

def format_as_multi_column(texts)
  column_width = calculate_column_width(texts)
  num_columns = texts.size == 4 ? 2 : [texts.size, MAX_COLUMNS].min
  num_rows = texts.size / num_columns + [texts.size % num_columns, 1].min

  rows = Array.new(num_rows) do |row_index|
    line = Array.new(num_columns) do |column_index|
      index = row_index + column_index * num_rows
      text = texts[index]
      next '' if text.nil?

      space_width = column_width - text.size
      num_tabs = space_width / TAB_SIZE + [space_width % TAB_SIZE, 1].min
      text + "\t" * num_tabs
    end

    "#{line.join.rstrip}\n"
  end

  rows.join
end

def calculate_column_width(texts)
  max_size = texts.max_by(&:size).size
  TAB_SIZE * (max_size / TAB_SIZE + 1)
end

if $PROGRAM_NAME == __FILE__
  options = ARGV.getopts('a')
  list_directory_contents(all: options['a'])
end
