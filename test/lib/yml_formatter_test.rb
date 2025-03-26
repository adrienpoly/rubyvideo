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

  test "normalize_commented_yaml_file formats the description field correctly" do
    input = <<~YAML
      ---
      - title: Some Title
        description: Some description
    YAML

    expected = <<~YAML
      ---
      - title: Some Title
        description: |-
          Some description
    YAML

    result = YmlFormatter.normalize_commented_yaml_file(input)
    assert_equal expected, result
  end

  test "normalize_commented_yaml_file formats the description field correctly when quoted" do
    input = <<~YAML
      ---
      - title: Some Title
        description:
          "Some description"
    YAML

    expected = <<~YAML
      ---
      - title: Some Title
        description: |-
          Some description
    YAML

    result = YmlFormatter.normalize_commented_yaml_file(input)
    assert_equal expected, result
  end

  test "normalize_commented_yaml_file formats the description field correctly when multilines and quoted text" do
    input = <<~YAML
      ---
      - title: Some Title
        description: "Technical.\n\nHelp stay\n\n"
    YAML

    expected = <<~YAML
      ---
      - title: Some Title
        description: |-
          Technical.
          Help stay
    YAML

    result = YmlFormatter.normalize_commented_yaml_file(input)
    assert_equal expected, result
  end

  test "normalize_commented_yaml_file formats the description field correctly and preserves internal linebreaks" do
    input = <<~YAML
      ---
      - title: Some Title
        description: |-
          line 1

          line 2

          line 3
    YAML

    expected = <<~YAML
      ---
      - title: Some Title
        description: |-
          line 1

          line 2

          line 3
    YAML

    result = YmlFormatter.normalize_commented_yaml_file(input)
    assert_equal expected, result
  end

  test "normalize it formats correctly the description field and preserves the emojis" do
    input = <<~YAML
      ---
      - test: "Beyond the current state: Time travel as answer to hard questions - Armin Pašalić - Balkan Ruby 2018 🚀"
      - title: Some Title
        description: |-
          line 1 🚀
    YAML

    expected = <<~YAML
      ---
      - test: "Beyond the current state: Time travel as answer to hard questions - Armin Pašalić - Balkan Ruby 2018 🚀"
      - title: Some Title
        description: |-
          line 1 🚀
    YAML

    result = YmlFormatter.normalize_commented_yaml_file(input)
    assert_equal expected, result
  end

  test "normalize special characters real world example" do
    input = <<~YAML
      ---
      - title: "lots of emojis"
        description: |-
          Join us for the next September PLRUG Ruby Warsaw Meetup!

          📆 19.09.2024
          ⏰ 18:00
          📍 Odolańska 56, Visuality office

          This time, the presentation topics will be very diverse. What's on the agenda?

          🎤 Barnaba Siegel - 28 lat CD-Action. Jak oldschoolowe medium radzi sobie wobec technologicznego postępu?
          🎤 Tomasz Stachewicz - Self-hosting and Homelab in 2024
          🎤 Urszula Sołogub - AI-assisted data extraction

          Be sure to come and join our community! We especially encourage those who have been quietly following us to join us.

          After the official part, as always, we encourage you to stay and get to know each other better.

          Language: One of the presentations will be in Polish.🇵🇱

          https://www.meetup.com/polishrubyusergroup/events/303197441
    YAML

    expected = <<~YAML
      ---
      - title: "lots of emojis"
        description: |-
          Join us for the next September PLRUG Ruby Warsaw Meetup!

          📆 19.09.2024
          ⏰ 18:00
          📍 Odolańska 56, Visuality office

          This time, the presentation topics will be very diverse. What's on the agenda?

          🎤 Barnaba Siegel - 28 lat CD-Action. Jak oldschoolowe medium radzi sobie wobec technologicznego postępu?
          🎤 Tomasz Stachewicz - Self-hosting and Homelab in 2024
          🎤 Urszula Sołogub - AI-assisted data extraction

          Be sure to come and join our community! We especially encourage those who have been quietly following us to join us.

          After the official part, as always, we encourage you to stay and get to know each other better.

          Language: One of the presentations will be in Polish.🇵🇱

          https://www.meetup.com/polishrubyusergroup/events/303197441
    YAML

    result = YmlFormatter.normalize_commented_yaml_file(input)
    assert_equal expected, result

    # ensure it is idempotent
    result = YmlFormatter.normalize_commented_yaml_file(result)
    assert_equal expected, result
  end
end
