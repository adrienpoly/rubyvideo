module ViewComponentHelper
  UI_HELPERS = {
    badge: "Ui::BadgeComponent",
    button: "Ui::ButtonComponent",
    divider: "Ui::DividerComponent",
    dropdown: "Ui::DropdownComponent",
    modal: "Ui::ModalComponent"
  }.freeze

  UI_HELPERS.each do |name, component|
    define_method :"ui_#{name}" do |*args, **kwargs, &block|
      render component.constantize.new(*args, **kwargs), &block
    end
  end

  def ui_tooltip(text, &block)
    tag.div data: {controller: "tooltip", tooltip_content_value: text} do
      yield
    end
  end

  def external_link_to(text, url = nil, **attributes, &)
    if block_given?
      url = text
      text = capture(&)
    end

    classes = class_names("link inline-flex items-center gap-2 flex-nowrap", attributes.delete(:class))
    link_to url, class: classes, target: "_blank", rel: "noopener noreferrer", **attributes do
      concat(content_tag(:span) { text }).concat(fa("arrow-up-right-from-square", size: :xs))
    end
  end
end
