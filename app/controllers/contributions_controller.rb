class ContributionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    speaker_ids_with_pending_github_suggestions = Suggestion.where("json_extract(content, '$.github') IS NOT NULL").where(suggestable_type: "Speaker").pluck(:suggestable_id)

    speakers = Speaker.without_github.order(talks_count: :desc)
    @speakers_without_github_count = speakers.count
    @speakers_without_github = speakers.where.not(id: speaker_ids_with_pending_github_suggestions).limit(11)

    speakers_with_speakerdeck = Speaker.where.not(speakerdeck: "")

    talks = Talk.joins(:speakers).where(slides_url: nil).where(speakers: {id: speakers_with_speakerdeck}).order(date: :desc)
    @talks_without_slides_count = talks.count
    @talks_without_slides = talks.limit(11)
  end
end
