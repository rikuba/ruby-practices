#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'etc'
require 'optparse'

def list_directory_contents(paths: nil, all: false, long: false, reverse: false)
  dirs, files, no_files = partition_paths(paths)

  no_files.each do |path|
    puts "ls: #{path}: No such file or directory"
  end

  blocks = []
  blocks << format_files(files, '.', long) unless files.empty?

  dirs.each do |dir|
    files = get_files(dir, all, reverse)
    blocks << (blocks.empty? ? '' : "#{dir}:\n") + format_files(files, dir, long)
  end

  print blocks.join("\n")
end

def partition_paths(paths)
  paths ||= []
  paths << '.' if paths.empty?
  files, no_files = paths.partition { |file| File.exist?(file) }
  dirs, files = files.partition { |file| File.directory?(file) }
  [dirs, files, no_files].map(&:sort)
end

def get_files(dir, include_dotfiles, reverse)
  flags = include_dotfiles ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags: flags, base: dir).sort
  reverse ? files.reverse : files
end

def format_files(files, dir, long)
  return format_as_multi_column(files) unless long

  content = nil
  Dir.chdir(dir) { content = format_as_long_format(files) }
  content
end

TAB_SIZE = 8
MAX_COLUMNS = 3

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

def format_as_long_format(files)
  current_time = Time.now
  entries = files.map { |file| make_entry(file, current_time) }

  total_blocks = entries.sum(&:blocks)
  nlink_width = entries.map(&:nlink).max.to_s.size
  owner_width = entries.map { |entry| entry.owner.size }.max
  group_width = entries.map { |entry| entry.group.size }.max
  size_or_device_width = entries.map { |entry| entry.size_or_device.size }.max

  entry_lines = entries.map do |entry|
    format(
      "%s  %#{nlink_width}d %-#{owner_width}s  %-#{group_width}s  %#{size_or_device_width}s %s %s\n",
      entry.mode, entry.nlink, entry.owner, entry.group, entry.size_or_device, entry.mtime, entry.pathname
    )
  end.join

  "total #{total_blocks}\n#{entry_lines}"
end

LsEntry = Struct.new(:mode, :nlink, :owner, :group, :size_or_device, :mtime, :pathname, :blocks)

SIX_MONTHS = 60 * 60 * 24 * 30 * 6

def make_entry(file, current_time)
  stat = File.lstat(file)
  mode = format_mode(stat.mode)
  owner_name = get_user_name(stat.uid)
  group_name = get_group_name(stat.gid)
  mtime = stat.mtime
  size_or_device = get_size_or_device(stat)
  last_modified = mtime.strftime('%m %d ').tr('0', ' ')
  diff = current_time - mtime
  last_modified += diff.abs <= SIX_MONTHS ? mtime.strftime('%H:%M') : " #{mtime.year}"
  pathname = file
  pathname += " -> #{File.realpath(file)}" if stat.symlink?

  LsEntry.new(
    mode, stat.nlink, owner_name, group_name, size_or_device,
    last_modified, pathname, stat.blocks
  )
end

def get_user_name(uid)
  Etc.getpwuid(uid).name
rescue ArgumentError
  uid.to_s
end

def get_group_name(gid)
  Etc.getgrgid(gid).name
rescue ArgumentError
  gid.to_s
end

def get_size_or_device(stat)
  case stat.ftype
  when 'characterSpecial', 'blockSpecial'
    "#{stat.rdev_major.to_s.rjust(3)}, #{stat.rdev_minor.to_s.rjust(3)}"
  else
    stat.size.to_s
  end
end

FILE_TYPES = [
  [0o140000, 's'],  # Socket link
  [0o120000, 'l'],  # Symbolic link
  [0o100000, '-'],  # Regular file
  [0o060000, 'b'],  # Block special file
  [0o040000, 'd'],  # Directory
  [0o020000, 'c'],  # Character special file
  [0o010000, 'p']   # FIFO
].freeze

SET_USER_ID_BIT  = 0o0004000
SET_GROUP_ID_BIT = 0o0002000
STICKY_BIT       = 0o0001000

def format_mode(mode)
  file_type = FILE_TYPES.find do |bitmask,|
    mode & bitmask == bitmask
  end[1]

  permissions = Array.new(9) do |i|
    (mode & (1 << i)).positive? ? 'xwr'[i % 3] : '-'
  end.reverse.join

  permissions[8] = permissions[8].tr('-x', 'Tt') if (mode & STICKY_BIT).positive?
  permissions[2] = permissions[2].tr('-x', 'Ss') if (mode & SET_USER_ID_BIT).positive?
  permissions[5] = permissions[5].tr('-x', 'Ss') if (mode & SET_GROUP_ID_BIT).positive?

  file_type + permissions
end

if $PROGRAM_NAME == __FILE__
  options = ARGV.getopts('alr')
  list_directory_contents(
    paths: ARGV,
    all: options['a'],
    long: options['l'],
    reverse: options['r']
  )
end
