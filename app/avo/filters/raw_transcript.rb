class Avo::Filters::RawTranscript < Avo::Filters::BooleanFilter
  self.name = "Raw transcript"
  # self.visible = -> do
  #   true
  # end

  def apply(request, query, values)
    return query if values["has_transcript"] && values["no_transcript"]

    if values["has_transcript"]
      query = query.with_raw_transcript
    elsif values["no_transcript"]
      query = query.without_raw_transcript
    end

    query
  end

  def options
    {
      has_transcript: "With raw transcript",
      no_transcript: "Without raw transcript"
    }
  end
end
