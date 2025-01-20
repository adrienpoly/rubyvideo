class Avo::Actions::FetchDuration < Avo::BaseAction
  self.name = "Fetch duration"

  def handle(query:, fields:, current_user:, resource:, **args)
    MeiliSearch::Rails.deactivate! do
      query.each do |record|
        record.fetch_duration_from_youtube_later!
      end
    end

    succeed "Fetching the duration in the background"
  end
end
