# frozen_string_literal: true

require "test_helper"

class ApplicationComponentTest < ViewComponent::TestCase
  class ButtonComponent < ApplicationComponent
    option :text, default: proc { "Click me" }

    def call
      content_tag(:span, text, **attributes)
    end
  end

  def test_preserves_attributes
    render_inline(ButtonComponent.new(text: "Click me", data: {controller: "button"}))
    assert_selector("span[data-controller=\"button\"]")
    refute_selector("span[title=\"Click me\"]")
    assert_content("Click me")
  end
end
