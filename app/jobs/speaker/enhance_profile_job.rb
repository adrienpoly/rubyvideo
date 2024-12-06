class Speaker::EnhanceProfileJob < ApplicationJob
  retry_on StandardError, attempts: 0
  limits_concurrency to: 1, key: "github_api"

  def perform(speaker:, sleep: 0)
    matching_profile = speaker.github.present? ? user_details(speaker.github) : search_github_profile(name: speaker.name)

    if matching_profile.present?
      speaker.update(
        twitter: speaker.twitter.presence || matching_profile.twitter_username || "",
        github: matching_profile.login,
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

  def user_details(username)
    GitHub::UserClient.new.profile(username)
  end

  def search_github_users(q:, per_page: 5, page: 1)
    GitHub::UserClient.new.search(q, per_page: per_page, page: page)
  end
end
