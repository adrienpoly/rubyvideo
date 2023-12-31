module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :set_slug
    validates :slug, presence: true
    validates :slug, uniqueness: true
  end

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = slug.presence || send(slug_source).parameterize
  end

  def slug_source
    self.class.slug_source
  end

  class_methods do
    attr_reader :slug_source

    def slug_from(attribute)
      @slug_source = attribute.to_sym
    end
  end
end
