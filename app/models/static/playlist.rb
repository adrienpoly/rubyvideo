module Static
  class Playlist < FrozenRecord::Base
    self.backend = Backends::MultiFileBackend.new("**/**/playlists.yml")
    self.base_path = Rails.root.join("data")
  end
end
