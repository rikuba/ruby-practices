# frozen_string_literal: true

require 'minitest/autorun'
require 'tempfile'
require './wc'

PROGRAM_PATH = File.absolute_path('./wc.rb')
LOREM_IPSUM = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'

class WcTest < Minitest::Test
  def test_wc_stdin
    assert_stdin "       0       4      14\n", 'This is a test'
    assert_stdin "       1       4      15\n", "This is a test\n"
    assert_stdin "       1       6      25\n", "This is a test\nExtra text"
    assert_stdin "       1       4      15\n", "This\tis\va\ftest\n"
    assert_stdin "       1       4      15\n", "This\nis\ra\u00A0test"
    assert_stdin "       1       4      18\n", " This is a test \n\t"
    assert_stdin "       1       1      28\n", "　日本語のテスト　\n"
    assert_stdin "       4       0       7\n", "\n\r\n\n\r\r\n"
    assert_stdin "       2       0       6\n", "\t\n\r\f\n\v"
    assert_stdin "  100000 1900000 12400000\n", "#{LOREM_IPSUM}\n" * 10**5
  end

  def test_wc_l_stdin
    assert_stdin "       0\n", 'This is a test', '-l'
    assert_stdin "       1\n", "This is a test\n", '-l'
    assert_stdin "       1\n", "This is a test\nExtra text", '-l'
    assert_stdin "       4\n", "\n\r\n\n\r\r\n", '-l'
    assert_stdin "       2\n", "\t\n\r\f\n\v", '-l'
    assert_stdin "    1000\n", "\n" * 1000, '-l'
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
    assert_equal <<~EXPECTED, `./wc.rb aaa bbb 2>&1`
      wc: aaa: open: No such file or directory
      wc: bbb: open: No such file or directory
             0       0       0 total
    EXPECTED
    assert_equal <<~EXPECTED, `./wc.rb . .. 2>&1`
      wc: .: read: Is a directory
      wc: ..: read: Is a directory
             0       0       0 total
    EXPECTED
  end

  private

  def assert_stdin(expected, text, options = '')
    Tempfile.create do |file|
      file.write(text)
      file.close
      assert_equal expected, `cat #{file.path} | #{PROGRAM_PATH} #{options}`
    end
  end
end
