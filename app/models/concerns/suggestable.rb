module Suggestable
  extend ActiveSupport::Concern

  included do
    has_many :suggestions, as: :suggestable, dependent: :destroy
  end

  def create_suggestion_from(params:, user: Current.user)
    suggestions.create(content: select_differences_for(params)).tap do |suggestion|
      suggestion.approved! if managed_by?(user)
    end
  end

  private

  def managed_by?(visiting_user)
    # this should be overitten in the model where the concern is included
    raise NotImplementedError, "This method should be implemented in the model where the concern is included"
  end

  def select_differences_for(params)
    params.reject do |key, value|
      self[key] == value
    end
  end
end
