# frozen_string_literal: true

module IconHelper
  SIZE_CLASSES = {
    xs: "h-4 w-4",
    sm: "h-5 w-5",
    md: "h-6 w-6",
    lg: "h-8 w-8",
    xl: "h-10 w-10"
  }

  # Add a class-level cache
  @svg_cache = {}

  class << self
    attr_reader :svg_cache

    def clear_cache
      @svg_cache.clear
    end
  end

  def cached_inline_svg(path, **options)
    cache_key = [path, options].hash

    IconHelper.svg_cache[cache_key] ||= begin
      full_path = Rails.root.join("app", "assets", "images", path)
      svg_content = File.read(full_path)

      if options[:class].present?
        # Simple string replacement for class attribute
        svg_content.sub!(/^<svg/, "<svg class=\"#{options[:class]}\"")
      end

      svg_content.html_safe
    end
  end

  def heroicon(icon_name, size: :md, variant: :outline, **options)
    classes = class_names(SIZE_CLASSES[size], options[:class])
    path = "icons/heroicons/#{variant}/#{icon_name.to_s.tr("_", "-")}.svg"
    cached_inline_svg(path, class: classes, **options.except(:class))
  end

  def fontawesome(icon_name, size: :md, type: nil, style: :solid, **options)
    classes = class_names(SIZE_CLASSES[size], options[:class])
    cached_inline_svg "icons/fontawesome/#{[icon_name, type, style].compact.join("-")}.svg", class: classes, **options.except(:class)
  end

  def fab(icon_name, **options)
    fontawesome(icon_name, type: :brands, **options.except(:type))
  end

  def fa(icon_name, **options)
    fontawesome(icon_name, **options.except(:type))
  end

  def icon(icon_name, size: :md, **options)
    classes = class_names(SIZE_CLASSES[size], options.delete(:class))
    cached_inline_svg("icons/icn-#{icon_name}.svg", class: classes, **options)
  end
end
