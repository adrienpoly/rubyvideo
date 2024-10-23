module Appsignal::AdminNamespace
  extend ActiveSupport::Concern

  included do
    before_action :set_appsignal_admin_namspace
  end

  def set_appsignal_admin_namspace
    return unless defined?(Appsignal)

    Appsignal.set_namespace("admin")
  end
end
