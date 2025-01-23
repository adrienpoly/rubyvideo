module Sociable
  extend ActiveSupport::Concern

  included do
    has_many :social_profiles, as: :sociable, dependent: :destroy
  end
end
