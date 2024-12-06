class Speaker::ProfileEnhancer < ActiveRecord::AssociatedObject
  BSKY_HOST = "api.bsky.app".freeze

  performs do
    retry_on StandardError, attempts: 3, wait: :polynomially_longer # TODO: replace with `retries: 3`.
    limits_concurrency key: -> { _1.id }
  end

  def enhance_all_later
    enhance_with_github_later
    enhance_with_bsky_later
  end

  performs def enhance_with_github
    # return unless speaker.github.present?

    # TODO: implement
  end

  def enhance_with_bsky_later
    return unless speaker.bsky.present?

    response = bsky.get_request("app.bsky.actor.getProfile", {
      actor: speaker.bsky
    })

    speaker.update!(bsky_metadata: response)
  end

  private

  def bsky
    @bsky ||= Minisky.new(BSKY_HOST, nil)
  end
end
