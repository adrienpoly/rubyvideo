require "minisky"

class Speaker::FetchBskyMetadata < ApplicationJob
  queue_as :low
  retry_on StandardError, attempts: 0
  limits_concurrency to: 1, key: "bsky"

  def perform(speaker:)
    return if speaker.bsky.blank?

    response = bsky.get_request('app.bsky.actor.getProfile', {
      actor: speaker.bsky
    })

    speaker.update!(bsky_metadata: response)
  end

  private

  def bsky
    @bsky ||= Minisky.new('api.bsky.app', nil)
  end
end
