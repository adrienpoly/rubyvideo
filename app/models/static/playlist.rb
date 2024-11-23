module Static
  class Playlist < FrozenRecord::Base
    self.backend = Backends::MultiFileBackend.new("**/**/playlists.yml")
    self.base_path = Rails.root.join("data")

    def future?
      start_date.present? && start_date.future?
    end

    def past?
      end_date.present? && end_date.past?
    end

    def start_date
      Date.parse(super)
    rescue TypeError
      super
    end

    def end_date
      Date.parse(super)
    rescue TypeError
      super
    end
  end
end
