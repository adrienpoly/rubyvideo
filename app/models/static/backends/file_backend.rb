module Static::Backends
  class FileBackend
    def initialize(file_path, backend: FrozenRecord::Backends::Yaml)
      @file_path = file_path
      @backend = backend
    end

    def filename(_model_name = nil)
      @file_path
    end

    def load(file_path = @file_path)
      @backend.load(file_path)
    end
  end
end
