module Static::Backends
  class MultiFileBackend
    def initialize(glob, backend: FrozenRecord::Backends::Yaml)
      @glob = glob
      @backend = backend
    end

    def filename(_model_name = nil)
      @glob
    end

    def load(file_path = @glob)
      Dir.glob(file_path).flat_map { |file|
        begin
          @backend.load(file)
        rescue Psych::SyntaxError => e
          puts "#{e.message} in #{file}"
          raise e
        end
      }
    end
  end
end
