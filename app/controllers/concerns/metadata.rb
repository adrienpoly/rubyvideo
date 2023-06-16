module Metadata
  extend ActiveSupport::Concern

  included do
    before_action :set_default_meta_tags
  end

  private

  def set_default_meta_tags
    set_meta_tags({
      description: "A collection of talks of Ruby conferences around the world, built using Rails 7.1, Hotwire and Mrsk"
    })
  end
end
