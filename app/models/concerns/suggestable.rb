module Suggestable
  extend ActiveSupport::Concern

  included do
    has_many :suggestions, as: :suggestable, dependent: :destroy
  end

  def create_suggestion_from(params:, user: Current.user)
    suggestions.create(content: select_differences_for(params)).tap do |suggestion|
      suggestion.approved! if user&.admin?
    end
  end

  private

  def select_differences_for(params)
    params.reject do |key, value|
      self[key] == value
    end
  end
end
