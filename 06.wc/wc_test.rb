# frozen_string_literal: true

require 'minitest/autorun'
require 'open3'
require './wc'

PROGRAM_PATH = File.absolute_path('./wc.rb')
LOREM_IPSUM = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'

class WcTest < Minitest::Test
  def test_wc_stdin
    assert_equal "       0       4      14\n", `printf 'This is a test' | #{PROGRAM_PATH}`
    assert_equal "       1       4      15\n", `printf 'This is a test\\n' | #{PROGRAM_PATH}`
    assert_equal "       1       6      25\n", `printf 'This is a test\\nExtra text' | #{PROGRAM_PATH}`
    assert_equal "       1       4      15\n", `printf 'This\\tis\\va\\ftest\\n' | #{PROGRAM_PATH}`
    assert_equal "       1       4      15\n", `printf 'This\\nis\\ra\u00A0test' | #{PROGRAM_PATH}`
    assert_equal "       1       4      18\n", `printf ' This is a test \\n\\t' | #{PROGRAM_PATH}`
    assert_equal "       1       1      28\n", `printf '　日本語のテスト　\\n' | #{PROGRAM_PATH}`
    assert_equal "       4       0       7\n", `printf '\\n\\r\\n\\n\\r\\r\\n' | #{PROGRAM_PATH}`
    assert_equal "       2       0       6\n", `printf '\\t\\n\\r\\f\\n\\v' | #{PROGRAM_PATH}`
    assert_equal "  100000 1900000 12400000\n", `printf '#{LOREM_IPSUM}\\n%.0s' {1..100000} | #{PROGRAM_PATH}`
  end

  def test_wc_l_stdin
    assert_equal "       0\n", `printf 'This is a test' | #{PROGRAM_PATH} -l`
    assert_equal "       1\n", `printf 'This is a test\\n' | #{PROGRAM_PATH} -l`
    assert_equal "       1\n", `printf 'This is a test\\nExtra text' | #{PROGRAM_PATH} -l`
    assert_equal "       4\n", `printf '\\n\\r\\n\\n\\r\\r\\n' | #{PROGRAM_PATH} -l`
    assert_equal "       2\n", `printf '\\t\\n\\r\\f\\n\\v' | #{PROGRAM_PATH} -l`
    assert_equal "    1000\n", `printf '\\n%.s' {1..1000} | #{PROGRAM_PATH} -l`
  end

  def test_wc_file
    assert_equal <<~EXPECTED, `./wc.rb ../03.rake/hello_world.c`
      \       6      10      75 ../03.rake/hello_world.c
    EXPECTED
    assert_equal <<~EXPECTED, `./wc.rb ../03.rake/hello_world.c ../03.rake/Rakefile`
      \       6      10      75 ../03.rake/hello_world.c
      \      19      44     320 ../03.rake/Rakefile
      \      25      54     395 total
    EXPECTED
  end

  def test_wc_l_file
    assert_equal <<~EXPECTED, `./wc.rb -l ../03.rake/hello_world.c`
      \       6 ../03.rake/hello_world.c
    EXPECTED
    assert_equal <<~EXPECTED, `./wc.rb -l ../03.rake/hello_world.c ../03.rake/Rakefile`
      \       6 ../03.rake/hello_world.c
      \      19 ../03.rake/Rakefile
      \      25 total
    EXPECTED
  end

  def test_wc_no_file
    stdout, stderr, status = Open3.capture3('./wc.rb', 'aaa', 'bbb')
    assert_equal <<~EXPECTED, stdout
      \       0       0       0 total
    EXPECTED
    assert_equal <<~EXPECTED, stderr
      wc: aaa: open: No such file or directory
      wc: bbb: open: No such file or directory
    EXPECTED
    assert_equal 1, status.exitstatus

    stdout, stderr, status = Open3.capture3('./wc.rb', '.', '..')
    assert_equal <<~EXPECTED, stdout
      \       0       0       0 total
    EXPECTED
    assert_equal <<~EXPECTED, stderr
      wc: .: read: Is a directory
      wc: ..: read: Is a directory
    EXPECTED
    assert_equal 1, status.exitstatus
  end
end
