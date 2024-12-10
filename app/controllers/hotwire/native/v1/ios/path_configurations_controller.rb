class Hotwire::Native::V1::IOS::PathConfigurationsController < ActionController::Base
  def show
    render json: {
      "settings": {},
      "rules": [
        {
          "patterns": [
            "/player$"
          ],
          "properties": {
            "view_controller": "player"
          }
        },
        {
          "patterns": [
            "/new$",
            "/edit$"
          ],
          "properties": {
            "context": "modal"
          }
        }
      ]
    }
  end
end
