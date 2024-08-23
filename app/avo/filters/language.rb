class Avo::Filters::Language < Avo::Filters::SelectFilter
  self.name = "Language"

  # self.visible = -> do
  #   true
  # end

  def apply(request, query, language)
    if language
      query.where("language is ?", language)
    else
      query
    end
  end

  def options
    Language.used
  end
end
