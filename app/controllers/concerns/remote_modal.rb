module RemoteModal
  extend ActiveSupport::Concern
  include Turbo::ForceFrameResponse

  included do
    layout :define_layout
  end

  class_methods do
    def respond_with_remote_modal(options = {})
      before_action :enable_remote_modal, **options
      force_frame_response(**options)
    end
  end

  private

  def enable_remote_modal
    @remote_modal = true
  end

  def define_layout
    return "modal" if turbo_frame_request_id == "modal" && @remote_modal

    "application"
  end
end
