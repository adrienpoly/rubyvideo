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
    users = GitHub::UserClient.new
    return unless user = (speaker.github? && users.profile(speaker.github)) || users.from_matching(name: speaker.name)

    speaker.update! speaker.slice(:twitter, :bio, :website).compact_blank.
      with_defaults(github: user.login, twitter: user.twitter_username, bio: user.bio, website: user.blog)

    speaker.broadcast_about
  end

  performs def enhance_with_bsky
    if handle = speaker.bsky.presence
      speaker.update!(bsky_metadata: BlueSky.profile_metadata(handle))
    end
  end
end
