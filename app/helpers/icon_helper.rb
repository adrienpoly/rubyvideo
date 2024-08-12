# frozen_string_literal: true

module IconHelper
  SIZE_CLASSES = {
    xs: "h-3 w-3",
    sm: "h-4 w-4",
    md: "h-6 w-6",
    lg: "h-8 w-8",
    xl: "h-10 w-10"
  }

  def heroicon(icon_name, size: :md, variant: :outline, **options)
    classes = class_names(SIZE_CLASSES[size], options[:class])
    inline_svg_tag "icons/heroicons/#{variant}/#{icon_name.to_s.tr("_", "-")}.svg", class: classes
  end

  def icon(icon_name, size: :md, **)
    classes = SIZE_CLASSES[size]
    inline_svg_tag("icons/icn-#{icon_name}.svg", class: classes, **)
  end
end
