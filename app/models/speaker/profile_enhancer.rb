class Speaker::ProfileEnhancer < ActiveRecord::AssociatedObject
  BSKY_HOST = "api.bsky.app".freeze

  # TODO: investigate why this is crashing
  # performs :enhance_all!, queue_as: :low do
  #   retry_on StandardError, attempts: 3, wait: :polynomially_longer
  #   limits_concurrency to: 1, key: "github_api"
  # end

  def enhance_all!
    enhance_with_github!
    enhance_with_bsky!
  end

  def enhance_with_github!
    return unless speaker.github.present?

    profile = github_client.profile(speaker.github)
    socials = github_client.social_accounts(speaker.github)

    twitter, mastodon, bsky, linkedin = nil, nil, nil, nil

    socials.each do |social|
      case social.provider
      when "twitter"
        twitter = social.url
      when "mastodon"
        mastodon = social.url
      when "bluesky"
        bsky = social.url
      when "linkedin"
        linkedin = social.url
      end
    end

    speaker.update!(
      twitter: speaker.twitter.presence || twitter || "",
      mastodon: speaker.mastodon.presence || mastodon || "",
      bsky: speaker.bsky.presence || bsky || "",
      linkedin: speaker.linkedin.presence || linkedin || "",
      bio: speaker.bio.presence || profile.bio || "",
      website: speaker.website.presence || profile.blog || "",
      github_metadata: {
        profile: JSON.parse(profile.body),
        socials: JSON.parse(socials.body)
      }
    )

    speaker.broadcast_header
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

  def github_client
    @github_client ||= GitHub::UserClient.new
  end
end
