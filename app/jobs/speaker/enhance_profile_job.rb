class Speaker::EnhanceProfileJob < ApplicationJob
  queue_as :low
  retry_on StandardError, attempts: 0
  limits_concurrency to: 1, key: "github_api"

  def perform(speaker:, sleep: 0)
    return if speaker.github.blank?

    profile = user_details(speaker.github)
    socials = user_social_accounts(speaker.github)

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

    speaker.update(
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

    speaker.broadcast_about
    sleep(sleep)
  end

  private

  def user_details(username)
    client.profile(username)
  end

  def user_social_accounts(username)
    client.social_accounts(username)
  end

  def client
    @client ||= GitHub::UserClient.new
  end
end
