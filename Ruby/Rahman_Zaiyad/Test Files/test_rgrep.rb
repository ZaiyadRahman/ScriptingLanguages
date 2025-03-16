require 'minitest/autorun'
require 'tempfile'

class RgrepTest < Minitest::Test
  def setup
    # Create a temporary test file with sample content
    @test_file = Tempfile.new(['test', '.txt'])
    @test_file.write(<<-CONTENT)
Hello world
12345 numbers
testing ruby code
RUBY is great
This has no matches
final line 999
    CONTENT
    @test_file.close

    @rgrep_path = "rgrep.rb"
  end

  def teardown
    @test_file.unlink
  end

  # Test basic pattern search (-p or default)
  def test_pattern_search
    output = `ruby #{@rgrep_path} #{@test_file.path} -p "ruby"`
    assert_includes output, "testing ruby code"
  end

  # Test default behavior (same as -p)
  def test_default_search
    output = `ruby #{@rgrep_path} #{@test_file.path} "ruby"`
    assert_includes output, "testing ruby code"
  end

  # Test word search (-w)
  def test_word_search
    output = `ruby #{@rgrep_path} #{@test_file.path} -w "RUBY"`
    assert_includes output, "RUBY is great"
    refute_includes output, "testing ruby code"
  end

  # Test inverse search (-v)
  def test_inverse_search
    output = `ruby #{@rgrep_path} #{@test_file.path} -v "ruby"`
    refute_includes output, "testing ruby code"
    assert_includes output, "Hello world"
    puts("Result: #{output}")
  end

  # Test counting matches (-c)
  def test_count_pattern_matches
    output = `ruby #{@rgrep_path} #{@test_file.path} -c -p "\\d+"`
    assert_equal "2\n", output
        puts("Result: #{output}")
  end

  def test_count_word_matches
    output = `ruby #{@rgrep_path} #{@test_file.path} -c -w "is"`
    assert_equal "1\n", output
        puts("Result: #{output}")
  end

  # Test matching parts (-m)
  def test_show_matching_parts
    output = `ruby #{@rgrep_path} #{@test_file.path} -m -p "\\d+"`
    assert_includes output, "12345"
    assert_includes output, "999"
        puts("Result: #{output}")
  end

  # Test error cases
  def test_invalid_option
    output = `ruby #{@rgrep_path} #{@test_file.path} -z "pattern"`
    assert_equal "Invalid option\n", output
        puts("Result: #{output}")
  end

  def test_missing_arguments
    output = `ruby #{@rgrep_path} #{@test_file.path}`
    assert_equal "Missing required arguments\n", output
        puts("Result: #{output}")
  end

  def test_invalid_combination
    output = `ruby #{@rgrep_path} #{@test_file.path} -p -w "pattern"`
    assert_equal "Invalid combination of options\n", output
        puts("Result: #{output}")
  end

  def test_invalid_c_m_combination
    output = `ruby #{@rgrep_path} #{@test_file.path} -p -c -m "pattern"`
    assert_equal "Invalid combination of options\n", output
        puts("Result: #{output}")
  end

  # Test duplicate options
  def test_duplicate_options
    output = `ruby #{@rgrep_path} #{@test_file.path} -p -p "ruby"`
    assert_includes output, "testing ruby code"
        puts("Result: #{output}")
  end
end
