module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :set_current_request_details
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    redirect_to sign_in_path unless Current.user
  end

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.ip
    Current.session = Session.find_by_id(cookies.signed[:session_token])
    # if cookies.signed[:session_token]
  end
end
