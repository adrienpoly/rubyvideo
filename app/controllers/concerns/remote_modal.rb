# frozen_string_literal: true

#
# include this module in your controller to respond with a remote modal
# if the request is a turbo frame request with a turbo_frame_id="modal"
# then the response will use the modal layout (wraps the content into a self opening modal)
#
module RemoteModal
  extend ActiveSupport::Concern
  DEFAULT_ALLOWED_ACTIONS = %i[new show edit index].freeze

  included do
    before_action :allowed_action?
    layout :define_layout
  end

  class_methods do
    #
    # provide a list of actions that should be allowed to be called remotely
    #
    # @param [Array<Symbol>] *actions list of actions that should be allowed to be called remotely
    #
    # @return [Array<Symbol>]
    #
    def allowed_remote_modal_actions(*actions)
      @allowed_actions = actions
    end

    def allowed_actions
      @allowed_actions || DEFAULT_ALLOWED_ACTIONS
    end
  end

  private

  def allowed_action?
    self.class.allowed_actions.include?(action_name.to_sym)
  end

  def define_layout
    return "modal" if turbo_frame_request_id == "modal" && allowed_action?

    "application"
  end
end
