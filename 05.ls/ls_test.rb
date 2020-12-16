# frozen_string_literal: true

require 'minitest/autorun'
require_relative './ls'

class LsTest < Minitest::Test
  def test_list_directory_contents
    Dir.chdir(__dir__) do
      assert_equal <<~EXPECTED, `./ls.rb`
        ls.rb		ls_test.rb
      EXPECTED
    end
  end

  def test_calculate_column_width
    assert_equal 8, calculate_column_width(['a' * 1])
    assert_equal 8, calculate_column_width(['a' * 7])
    assert_equal 16, calculate_column_width(['a' * 8])
    assert_equal 16, calculate_column_width(['a' * 15])
    assert_equal 24, calculate_column_width(['a' * 16])
  end

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
