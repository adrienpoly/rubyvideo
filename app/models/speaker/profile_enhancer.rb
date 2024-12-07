class Speaker::ProfileEnhancer < ActiveRecord::AssociatedObject
  BSKY_HOST = "api.bsky.app".freeze

  performs :enhance_all!, queue_as: :low do
    retry_on StandardError, attempts: 3, wait: :polynomially_longer
    limits_concurrency to: 1, key: "github_api"
  end

  def enhance_all!
    enhance_with_github!
    enhance_with_bsky!
  end

  def enhance_with_github!
    # return unless speaker.github.present?

    # TODO: implement
  end

  def enhance_with_bsky!
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
