require "test_helper"

class Speaker::ProfilesTest < ActiveSupport::TestCase
  test "enhance_with_github with GitHub profile" do
    VCR.use_cassette("speaker/enhance_profile_job_test") do
      speaker = Speaker.create!(name: "Aaron Patterson", github: "tenderlove")

      speaker.profiles.enhance_with_github
      speaker.reload

      assert_equal "tenderlove", speaker.github
      assert_equal "tenderlove", speaker.twitter
      assert_equal "tenderlove.dev", speaker.bsky
      assert_equal "https://mastodon.social/@tenderlove", speaker.mastodon

      assert speaker.bio?
      assert speaker.github_metadata?

      assert_equal 3124, speaker.github_metadata.dig("profile", "id")
      assert_equal "https://twitter.com/tenderlove", speaker.github_metadata.dig("socials", 0, "url")
    end
  end

  test "enhance_with_github with no GitHub handle" do
    speaker = Speaker.create!(name: "Nathan Bibler")

    speaker.profiles.enhance_with_github
    speaker.reload

    assert_equal "", speaker.github
    assert_equal({}, speaker.github_metadata)
  end
end
