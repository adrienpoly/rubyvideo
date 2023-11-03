# frozen_string_literal: true

require "test_helper"

class Ui::BadgeComponentTest < ViewComponent::TestCase
  def test_render_a_badge_with_text
    render_inline(Ui::BadgeComponent.new("New"))
    assert_text("New")
  end

  def test_render_default_primary_badge
    render_inline(Ui::BadgeComponent.new("New"))
    assert_selector(".badge.badge-primary")
  end

  def test_render_secondary_badge
    render_inline(Ui::BadgeComponent.new("New", kind: :secondary))
    assert_selector(".badge.badge-secondary")
  end

  def test_render_with_custom_size
    render_inline(Ui::BadgeComponent.new("New", size: :lg))
    assert_selector(".badge.badge-lg")
  end

  def test_render_with_outline
    render_inline(Ui::BadgeComponent.new("New", outline: true))
    assert_selector(".badge.badge-outline")
  end

  def test_render_with_custom_attributes
    render_inline(Ui::BadgeComponent.new("New", data: {controller: "hello"}))
    assert_selector("span[data-controller=\"hello\"]")
  end

  def test_render_with_content
    render_inline(Ui::BadgeComponent.new.with_content("New"))
    assert_text("New")
  end
end
