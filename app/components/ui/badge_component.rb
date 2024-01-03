# frozen_string_literal: true

class Ui::BadgeComponent < ApplicationComponent
  KIND_MAPPING = {
    neutral: "badge-neutral",
    primary: "badge-primary",
    secondary: "badge-secondary",
    accent: "badge-accent",
    info: "badge-info",
    success: "badge-success",
    warning: "badge-warning",
    error: "badge-error",
    ghost: "badge-ghost"
  }

  SIZE_MAPPING = {
    xs: "badge-xs",
    sm: "badge-sm",
    md: "badge-md",
    lg: "badge-lg"
  }

  param :text, optional: true
  option :kind, type: Dry::Types["coercible.symbol"].enum(*KIND_MAPPING.keys), default: proc { :primary }
  option :size, type: Dry::Types["coercible.symbol"].enum(*SIZE_MAPPING.keys), default: proc { :md }
  option :outline, type: Dry::Types["strict.bool"], default: proc { false }

  def call
    content_tag(:span, class: classes, **attributes.except(:class)) do
      concat content
    end
  end

  private

  def classes
    [component_classes, attributes[:class]].join(" ")
  end

  def component_classes
    class_names(
      "badge",
      KIND_MAPPING[kind],
      SIZE_MAPPING[size],
      "badge-outline": outline
    )
  end

  def content
    text.presence || super
  end
end
