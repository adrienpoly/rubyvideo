module Static
  class Organisation < FrozenRecord::Base
    self.backend = Backends::FileBackend.new("organisations.yml")
    self.base_path = Rails.root.join("data")
  end
end
