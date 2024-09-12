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
end
