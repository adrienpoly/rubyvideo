class Hotwire::Native::V1::IOS::PathConfigurationsController < ActionController::Base
  def show
    render json: {
      "settings": {},
      "rules": [
        {
          "patterns": [
            "^$",
            "^/$",
            "^/home$"
          ],
          "properties": {
            "view_controller": "home"
          }
        },
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
