class Avo::Filters::EnhancedTranscript < Avo::Filters::BooleanFilter
  self.name = "Enhanced transcript"
  # self.visible = -> do
  #   true
  # end

  def apply(request, query, values)
    return query if values["has_enhanced_transcript"] && values["no_enhanced_transcript"]

    if values["has_enhanced_transcript"]
      query = query.with_enhanced_transcript
    elsif values["no_enhanced_transcript"]
      query = query.without_enhanced_transcript
    end

    query
  end

  def options
    {
      has_enhanced_transcript: "With enhanced transcript",
      no_enhanced_transcript: "Without enhanced transcript"
    }
  end
end
