require "test_helper"

class IconHelperTest < ActionView::TestCase
  setup do
    IconHelper.clear_cache
    @icon = "icons/fontawesome/pen-solid.svg"
  end

  test "caches the SVG content" do
    first_result = cached_inline_svg(@icon)
    second_result = cached_inline_svg(@icon)
    assert_equal first_result, second_result
  end

  test "adds class attribute" do
    result = cached_inline_svg(@icon, class: "icon-class")
    assert_includes result, 'class="icon-class"'
  end

  test "adds data attributes" do
    result = cached_inline_svg(@icon, data: {test: "value"})
    assert_includes result, 'data-test="value"'
  end

  test "adds aria attributes" do
    result = cached_inline_svg(@icon, aria: {label: "Test Icon"})
    assert_includes result, 'aria-label="Test Icon"'
  end

  test "preserves existing viewBox attribute while adding new attributes" do
    result = cached_inline_svg(@icon, class: "icon-class")
    assert_includes result, 'viewBox="0 0 512 512"'
    assert_includes result, 'class="icon-class"'
    assert_not_includes result, 'hidden="true"'
  end

  test "handles multiple attributes" do
    result = cached_inline_svg(@icon,
      class: "icon-class",
      data: {test: "value"},
      aria: {label: "Test Icon"},
      role: "img")

    assert_includes result, 'class="icon-class"'
    assert_includes result, 'data-test="value"'
    assert_includes result, 'aria-label="Test Icon"'
    assert_includes result, 'role="img"'
  end

  test "escapes attribute values" do
    result = cached_inline_svg(@icon, data: {test: 'value"with"quotes'})
    assert_includes result, 'data-test="value&quot;with&quot;quotes"'
  end

  test "heroicon" do
    result = heroicon("magnifying-glass", size: :md)
    assert_includes result, 'viewBox="0 0 24 24"'
    assert_includes result, 'class="h-6 w-6"'
    assert_includes result, 'aria-hidden="true"'
    assert_not_includes result, ' hidden="true"'

    # Verify SVG structure
    doc = Nokogiri::HTML.fragment(result)
    svg = doc.at_css("svg")

    assert_not_nil svg, "Should be a valid SVG element"
    assert_equal "svg", svg.name
    assert_not_nil svg.at_css("path"), "SVG should contain a path element"

    # Verify proper closing of tags
    assert result.include?("</svg>"), "SVG should have a closing tag"
    assert_match(/<svg[^>]*>.*<\/svg>/m, result, "SVG should be properly closed")
  end
end
