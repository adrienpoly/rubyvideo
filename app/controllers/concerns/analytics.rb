module Analytics
  extend ActiveSupport::Concern

  included do
    after_action :track_action
  end

  private

  def track_action
    ahoy.track "#{controller_path}##{action_name}", request.path_parameters
  end
end
