module Static::Backends
  class ArrayBackend < FileBackend
    def load(...)
      super.map { |item| {"item" => item} }
    end
  end
end
