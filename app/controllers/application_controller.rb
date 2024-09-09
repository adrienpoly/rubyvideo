class ApplicationController < ActionController::Base
  include Authenticable
  include Metadata
  include Analytics

  helper_method :default_watch_list

  def default_watch_list
    @default_watch_list ||= Current.user&.default_watch_list
  end
end
