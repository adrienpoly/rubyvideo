module ApplicationHelper
  include Pagy::Frontend

  def back_path
    @back_path || root_path
  end
end
