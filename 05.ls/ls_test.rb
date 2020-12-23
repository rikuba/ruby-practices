# frozen_string_literal: true

require 'fileutils'
require 'minitest/autorun'
require 'tmpdir'
require_relative './ls'

class LsTest < Minitest::Test
  PROGRAM_PATH = File.absolute_path('./ls.rb')

  FILENAMES1 = [
    'babel.config.js', 'bin', 'config', 'config.ru', 'Gemfile', 'Gemfile.lock',
    'log', 'package.json', 'postcss.config.js', 'Procfile', 'README.md'
  ].freeze

  def test_ls
    chtmpdir do
      FileUtils.touch(FILENAMES1)
      assert_equal <<~EXPECTED, `#{PROGRAM_PATH}`
        Gemfile			babel.config.js		log
        Gemfile.lock		bin			package.json
        Procfile		config			postcss.config.js
        README.md		config.ru
      EXPECTED
    end
  end

  def test_ls_with_a
    chtmpdir do
      FileUtils.touch(FILENAMES1)
      assert_equal <<~EXPECTED, `#{PROGRAM_PATH} -a`
        .			README.md		log
        ..			babel.config.js		package.json
        Gemfile			bin			postcss.config.js
        Gemfile.lock		config
        Procfile		config.ru
      EXPECTED
    end
  end

  def test_ls_with_r
    chtmpdir do
      FileUtils.touch(FILENAMES1)
      assert_equal <<~EXPECTED, `#{PROGRAM_PATH} -r`
        postcss.config.js	config			Procfile
        package.json		bin			Gemfile.lock
        log			babel.config.js		Gemfile
        config.ru		README.md
      EXPECTED
    end
  end

  def test_ls_with_a_r
    chtmpdir do
      FileUtils.touch(FILENAMES1)
      expected = <<~EXPECTED
        postcss.config.js	bin			Gemfile
        package.json		babel.config.js		..
        log			README.md		.
        config.ru		Procfile
        config			Gemfile.lock
      EXPECTED
      assert_equal expected, `#{PROGRAM_PATH} -ar`
      assert_equal expected, `#{PROGRAM_PATH} -ra`
    end
  end

  def test_ls_with_files
    chtmpdir do
      FileUtils.touch(FILENAMES1)
      assert_equal "Gemfile.lock\n", `#{PROGRAM_PATH} Gemfile.lock`
      assert_equal "Gemfile\t\tGemfile.lock\n", `#{PROGRAM_PATH} Gemfile*`
      assert_equal <<~EXPECTED, `#{PROGRAM_PATH} *config*`
        babel.config.js		config.ru
        config			postcss.config.js
      EXPECTED
    end
  end

  private

  def chtmpdir(&proc)
    Dir.mktmpdir do |dir|
      Dir.chdir(dir, &proc)
    end
  end
end

class CalculateColumnWidthTest < Minitest::Test
  def test_calculate_column_width
    assert_equal 8, calculate_column_width(['a' * 1])
    assert_equal 8, calculate_column_width(['a' * 7])
    assert_equal 16, calculate_column_width(['a' * 8])
    assert_equal 16, calculate_column_width(['a' * 15])
    assert_equal 24, calculate_column_width(['a' * 16])
  end

  def test_calculate_column_width_contains_japanese
    assert_equal 8, calculate_column_width(['あ' * 1])
    assert_equal 8, calculate_column_width(["#{'あ' * 3}a"])
    assert_equal 16, calculate_column_width(['あ' * 4])
    assert_equal 16, calculate_column_width(["aa#{'あ' * 2}aa"])
    assert_equal 24, calculate_column_width(['あ' * 8])
  end
end

class FormatAsMultiColumnTest < Minitest::Test
  def test_format_as_multi_column
    assert_equal "a\n", format_as_multi_column(%w[a])
    assert_equal "a\tb\n", format_as_multi_column(%w[a b])
    assert_equal "a\tb\tc\n", format_as_multi_column(%w[a b c])
    assert_equal "a\tc\nb\td\n", format_as_multi_column(%w[a b c d])
    assert_equal "a\tc\te\nb\td\n", format_as_multi_column(%w[a b c d e])
    assert_equal "a\tc\te\nb\td\tf\n", format_as_multi_column(%w[a b c d e f])
    assert_equal <<~EXPECTED, format_as_multi_column(%w[a b c d e f g])
      a\td\tg
      b\te
      c\tf
    EXPECTED
    assert_equal <<~EXPECTED, format_as_multi_column(%w[a b c d e f g h])
      a\td\tg
      b\te\th
      c\tf
    EXPECTED
    assert_equal <<~EXPECTED, format_as_multi_column(%w[a b c d e f g h i])
      a\td\tg
      b\te\th
      c\tf\ti
    EXPECTED
  end

  def test_format_as_multi_column_long_text
    assert_equal "#{'a' * 8}\tb\t\tc\n", format_as_multi_column(%W[#{'a' * 8} b c])
    assert_equal "a\t\t\t#{'b' * 16}\tc\n", format_as_multi_column(%W[a #{'b' * 16} c])
    assert_equal "a\t\t\t\tb\t\t\t\t#{'c' * 24}\n", format_as_multi_column(%W[a b #{'c' * 24}])
    assert_equal <<~EXPECTED, format_as_multi_column(%W[a b c #{'d' * 8}])
      a\t\tc
      b\t\t#{'d' * 8}
    EXPECTED
    assert_equal <<~EXPECTED, format_as_multi_column(%W[a #{'b' * 24} c #{'d' * 10} e f g #{'h' * 18} i])
      a\t\t\t\t#{'d' * 10}\t\t\tg
      #{'b' * 24}\te\t\t\t\t#{'h' * 18}
      c\t\t\t\tf\t\t\t\ti
    EXPECTED
  end
end

class FormatModeTest < Minitest::Test
  def test_format_mode
    assert_equal 'prw-rw-rw-', format_mode(0o010666)
    assert_equal 'crw-rw-rw-', format_mode(0o020666)  # /dev/random
    assert_equal 'drwxr-xr-x', format_mode(0o040755)
    assert_equal 'drwxrwxrwt', format_mode(0o041777)  # /private/tmp
    assert_equal 'drwxrwxrwT', format_mode(0o041776)
    assert_equal 'brw-r-----', format_mode(0o060640)  # /dev/disk1
    assert_equal '-rw-r--r--', format_mode(0o100644)
    assert_equal '-rwsr-xr-x', format_mode(0o104755)  # /usr/bin/su
    assert_equal '-rwxr-sr-x', format_mode(0o102755)
    assert_equal '-rwSr-Sr--', format_mode(0o106644)
    assert_equal 'lr-xr-xr-x', format_mode(0o120555)  # /dev/stdin
    assert_equal 'sr-xr--r--', format_mode(0o140544)
  end
end
