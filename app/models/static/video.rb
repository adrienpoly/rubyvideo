module Static
  class Video < FrozenRecord::Base
    self.backend = Backends::MultiFileBackend.new("**/**/videos.yml")
    self.base_path = Rails.root.join("data")
  end
end
