class ApplicationController < ActionController::Base
  include Authenticable
  include Metadata
  include Analytics
end
