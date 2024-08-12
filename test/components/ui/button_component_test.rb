# frozen_string_literal: true

require "test_helper"

class Ui::ButtonComponentTest < ViewComponent::TestCase
  def test_render_a_button_with_text
    render_inline(Ui::ButtonComponent.new("click me"))
    assert_text("click me")
  end

  def test_render_with_custom_attributes
    render_inline(Ui::ButtonComponent.new("click me", data: {controller: "hello"}))
    assert_selector("button[data-controller=\"hello\"]")
  end

  def test_render_default_primary_button
    render_inline(Ui::ButtonComponent.new("click me"))
    assert_selector(".btn.btn-primary")
  end

  def test_render_secondary_button
    render_inline(Ui::ButtonComponent.new("click me", kind: :secondary))
    assert_selector(".btn.btn-secondary")
  end

  def test_render_with_content
    render_inline(Ui::ButtonComponent.new.with_content("click me"))
    assert_text("click me")
  end

  def test_render_button_to_form
    render_inline(Ui::ButtonComponent.new("click me", url: "https://example.com", method: :post))
    assert_selector("form[action=\"https://example.com\"][method=post]")
  end

  def test_render_link_to
    render_inline(Ui::ButtonComponent.new("click me", url: "https://example.com"))
    assert_selector("a[href=\"https://example.com\"]")
  end
end
