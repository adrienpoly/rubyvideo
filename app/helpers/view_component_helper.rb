module ViewComponentHelper
  UI_HELPERS = {
    button: "Ui::ButtonComponent"
  }.freeze

  UI_HELPERS.each do |name, component|
    define_method "ui_#{name}" do |*args, **kwargs, &block|
      render component.constantize.new(*args, **kwargs), &block
    end
  end
end
