# frozen_string_literal: true

require 'etc'

module Ls
  class FileTable
    def initialize(files)
      @files = files
    end

    def render(params)
      rows = @files.map do |file|
        Row.new(file).cells
      end

      widths = rows.transpose.map do |column|
        column.map(&:size).max
      end

      format_string = "%*s %*d %*s  %*s  %*d %*s %s\n".gsub('*') { widths.shift }

      (params[:blocks] ? total_blocks : '') + rows.map do |cells|
        format(format_string, *cells)
      end.join
    end

    private

    def total_blocks
      total_blocks = @files.sum { |file| file.stat.blocks }
      "total #{total_blocks}\n"
    end
  end

  class FileTable::Row
    TIME_FORMAT_STRING =
      if ENV['LANG']&.start_with?('ja_JP')
        '%_m %_d %H:%M'
      else
        '%b %_d %H:%M'
      end

    def initialize(file)
      @name = file.name
      @stat = file.stat
    end

    def cells
      [
        mode,
        @stat.nlink.to_s,
        user_name,
        group_name,
        @stat.size.to_s,
        mtime,
        @name
      ]
    end

    private

    def mode
      ftype = @stat.ftype == 'file' ? '-' : @stat.ftype[0]
      extended_attributes = ' ' # Not implemented
      ftype + permissions + extended_attributes
    end

    def permissions
      Array.new(9) do |i|
        (@stat.mode & (1 << i)).positive? ? 'xwr'[i % 3] : '-'
      end.reverse.join
    end

    def user_name
      Etc.getpwuid(@stat.uid).name
    rescue ArgumentError
      @stat.uid.to_s
    end

    def group_name
      Etc.getgrgid(@stat.gid).name
    rescue ArgumentError
      @stat.gid.to_s
    end

    def mtime
      @stat.mtime.strftime(TIME_FORMAT_STRING)
    end
  end
end
