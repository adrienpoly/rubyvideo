require "test_helper"

class Speaker::ProfilesTest < ActiveSupport::TestCase
  test "find aaron" do
    VCR.use_cassette("speaker/enhance_profile_job_test") do
      @speaker = Speaker.create!(name: "Aaron Patterson")
      @speaker.profiles.enhance_with_github
      assert_equal "tenderlove", @speaker.reload.github
      assert @speaker.bio?
    end
  end

  test "a user not found on GitHub" do
    VCR.use_cassette("speaker/enhance_profile_job_test_user_not_found") do
      @speaker = Speaker.create!(name: "Nathan Bibler")
      @speaker.profiles.enhance_with_github
      assert_equal "", @speaker.reload.github
    end
  end

  test "search Hampton Catlin" do
    VCR.use_cassette("speaker/enhance_profile_job_test_search_hampton_catlin") do
      @speaker = Speaker.create!(name: "Hampton Catlin")
      @speaker.profiles.enhance_with_github
      assert_equal "HamptonMakes", @speaker.reload.github
    end
  end

  test "search Design a user with no name" do
    VCR.use_cassette("speaker/enhance_profile_job_test_search_design") do
      @speaker = Speaker.create!(name: "Design")
      @speaker.profiles.enhance_with_github
      assert_equal "Design-and-Code", @speaker.reload.github
    end
  end
end
