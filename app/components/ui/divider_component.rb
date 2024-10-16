# frozen_string_literal: true

class Ui::DividerComponent < ApplicationComponent
  KIND_MAPPING = {
    horizontal: "divider-horizontal",
    vertical: "divider-vertical"
  }

  param :text, optional: true
  option :kind, type: Dry::Types["coercible.symbol"].enum(*KIND_MAPPING.keys), optional: true

  def call
    content_tag(:div, class: classes, **attributes.except(:class)) do
      concat content
    end
  end

  private

  def classes
    [component_classes, attributes[:class]].join(" ")
  end

  def component_classes
    class_names(
      "divider",
      KIND_MAPPING[kind]
    )
  end

  def content
    text.presence || super
  end
end
