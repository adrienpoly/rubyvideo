# frozen_string_literal: true

class Ui::ModalComponent < ApplicationComponent
  POSITION_MAPPING = {
    top: "modal-top",
    bottom: "modal-bottom",
    middle: "modal-middle",
    responsive: "modal-bottom sm:modal-middle"
  }

  option :open, type: Dry::Types["strict.bool"], default: proc { false }
  option :position, type: Dry::Types["coercible.symbol"].enum(*POSITION_MAPPING.keys), optional: true, default: proc { :responsive }

  private

  def before_render
    attributes[:data] = {controller: "modal", modal_open_value: open, action: "keydow->modal#close"}
  end

  def classes
    [component_classes, attributes.delete(:class)].compact_blank.join(" ")
  end

  def component_classes
    class_names(
      "modal",
      POSITION_MAPPING[position]
    )
  end

  def content_classes
    class_names("dropdown-content menu menu-smp-2 mt-4 w-max z-[1] rounded-lg shadow-2xl bg-white text-neutral", attributes.delete(:content_classes))
  end
end
