class Speaker::Profiles < ActiveRecord::AssociatedObject
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

  performs def enhance_with_bsky
    if handle = speaker.bsky.presence
      speaker.update!(bsky_metadata: BlueSky.profile_metadata(handle))
    end
  end
end
