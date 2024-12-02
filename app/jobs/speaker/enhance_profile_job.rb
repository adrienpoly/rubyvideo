class Speaker::EnhanceProfileJob < ApplicationJob
  queue_as :low
  retry_on StandardError, attempts: 0
  limits_concurrency to: 1, key: "github_api"

  def perform(speaker:, sleep: 0)
    matching_profile = speaker.github.present? ? user_details(speaker.github) : search_github_profile(name: speaker.name)

    if matching_profile.present?
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
        bio: speaker.bio.presence || matching_profile.bio || "",
        website: speaker.website.presence || matching_profile.blog || ""
      )
    end
    speaker.broadcast_about
    sleep(sleep)
  end

  private

  def search_github_profile(name:)
    list_of_potential_profiles = search_github_users(q: name).parsed_body

    bag_of_names = Set.new(name.downcase.split)
    list_of_potential_profiles.items&.find do |profile|
      request = user_details(profile.login)

      github_profile = request.parsed_body

      break github_profile if bag_of_names.subset?(Set.new(github_profile.name&.downcase&.split(/[ -]/)))
    end
  end

  def user_social_accounts(username)
    client.social_accounts(username).parsed_body
  end

  def user_details(username)
    client.profile(username)
  end

  def search_github_users(q:, per_page: 5, page: 1)
    client.search(q, per_page: per_page, page: page)
  end

  def client
    @client ||= GitHub::UserClient.new
  end
end
