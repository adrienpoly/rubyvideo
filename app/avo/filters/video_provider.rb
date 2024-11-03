class Avo::Filters::VideoProvider < Avo::Filters::SelectFilter
  self.name = "Video Provider"

  # self.visible = -> do
  #   true
  # end

  def apply(request, query, provider)
    if provider
      query.where(video_provider: provider)
    else
      query
    end
  end

  def options
    Talk.video_providers
  end
end
