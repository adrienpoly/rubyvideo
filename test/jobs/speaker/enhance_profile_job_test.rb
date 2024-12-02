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
    end
  end

  test "a user with no GitHub handle" do
    speaker = Speaker.create!(name: "Nathan Bibler")

    Speaker::EnhanceProfileJob.new.perform(speaker: speaker)

    assert_equal "", speaker.reload.github
  end
end
