require "test_helper"
require "yml_formatter"

class YmlFormatterTest < ActiveSupport::TestCase
  test "normalize_comment_lines formats consecutive comments correctly" do
    # Comments without empty lines between them
    input = <<~YAML
      ---
      # Comment 1
      # Comment 2
      # Comment 3
      title: Some Title
      description: Some description
    YAML

    expected = <<~YAML
      ---
      #
      # Comment 1
      # Comment 2
      # Comment 3
      #
      title: Some Title
      description: Some description
    YAML

    result = YmlFormatter.normalize_comment_lines(input)
    assert_equal expected, result

    # ensure it is idempotent
    result = YmlFormatter.normalize_comment_lines(result)
    assert_equal expected, result
  end

  test "normalize_comment_lines don't change already formatted comments" do
    input = <<~YAML
      ---
      #
      # Comment 1
      #
      # Comment 2
      # Comment 3
      title: Some Title
      description: Some description
    YAML

    expected = <<~YAML
      ---
      #
      # Comment 1
      #
      # Comment 2
      # Comment 3
      #
      title: Some Title
      description: Some description
    YAML

    result = YmlFormatter.normalize_comment_lines(input)
    assert_equal expected, result

    # ensure it is idempotent
    result = YmlFormatter.normalize_comment_lines(result)
    assert_equal expected, result
  end

  test "normalize_comment_lines formats comments with empty lines correctly" do
    # Comments with existing empty lines
    input = <<~YAML
      ---
      # Comment 1

      # Comment 2

      # Comment 3
      title: Some Title
    YAML

    expected = <<~YAML
      ---
      #
      # Comment 1
      # Comment 2
      # Comment 3
      #
      title: Some Title
    YAML

    result = YmlFormatter.normalize_comment_lines(input)
    assert_equal expected, result

    # ensure it is idempotent
    result = YmlFormatter.normalize_comment_lines(result)
    assert_equal expected, result
  end

  test "normalize_comment_lines handles content without comments correctly" do
    # No comments
    input = <<~YAML
      title: Some Title
      description: Some description
    YAML

    expected = <<~YAML
      title: Some Title
      description: Some description
    YAML

    result = YmlFormatter.normalize_comment_lines(input)
    assert_equal expected, result

    # ensure it is idempotent
    result = YmlFormatter.normalize_comment_lines(result)
    assert_equal expected, result
  end

  test "normalize_comment_lines preserves end of file comments" do
    input = <<~YAML
      title: Some Title
      description: Some description
      # End of file comment
    YAML

    expected = <<~YAML
      title: Some Title
      description: Some description
      # End of file comment
    YAML

    result = YmlFormatter.normalize_comment_lines(input)
    assert_equal expected, result

    # ensure it is idempotent
    result = YmlFormatter.normalize_comment_lines(result)
    assert_equal expected, result
  end
end
