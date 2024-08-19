module Static
  class Speaker < FrozenRecord::Base
    self.backend = Backends::FileBackend.new("speakers.yml")
    self.base_path = Rails.root.join("data")
  end
end
