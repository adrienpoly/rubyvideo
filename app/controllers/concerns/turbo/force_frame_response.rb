# frozen_string_literal: true

module Turbo
  module ForceFrameResponse
    extend ActiveSupport::Concern

    class_methods do
      def force_frame_response(options = {})
        before_action :force_frame_response, **options
      end
    end

    def force_frame_response
      return if turbo_frame_request?

      redirect_to(request.referer || root_path)
    end
  end
end
