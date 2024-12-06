require "test_helper"

class Speaker::EnhanceProfileJobTest < ActiveJob::TestCase
  test "find aaron" do
    VCR.use_cassette("speaker/enhance_profile_job_test") do
      speaker = Speaker.create!(name: "Aaron Patterson", github: "tenderlove")

      Speaker::EnhanceProfileJob.new.perform(speaker: speaker)

      speaker.reload

      assert_equal "tenderlove", speaker.github
      assert_equal "tenderlove", speaker.twitter
      assert_equal "tenderlove.dev", speaker.bsky
      assert_equal "https://mastodon.social/@tenderlove", speaker.mastodon

      assert speaker.bio.present?
      assert speaker.github_metadata.present?

      assert_equal 3124, speaker.github_metadata.dig("profile", "id")
      assert_equal "https://twitter.com/tenderlove", speaker.github_metadata.dig("socials", 0, "url")
    end
  end

  test "a user with no GitHub handle" do
    speaker = Speaker.create!(name: "Nathan Bibler")

    Speaker::EnhanceProfileJob.new.perform(speaker: speaker)

    speaker.reload

    assert_equal "", speaker.github
    assert_equal({}, speaker.github_metadata)
  end
end
