module Static
  class IgnoredVideo < FrozenRecord::Base
    self.backend = Backends::ArrayBackend.new("videos_to_ignore.yml")
    self.base_path = Rails.root.join("data")
  end
end
