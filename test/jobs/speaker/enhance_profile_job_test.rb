require "test_helper"

class Speaker::EnhanceProfileJobTest < ActiveJob::TestCase
  test "find aaron" do
    VCR.use_cassette("speaker/enhance_profile_job_test") do
      @speaker = Speaker.create!(name: "Aaron Patterson")
      Speaker::EnhanceProfileJob.new.perform(@speaker)
      assert_equal "tenderlove", @speaker.reload.github
      assert @speaker.bio.present?
    end
  end

  test "a user not found on Github" do
    VCR.use_cassette("speaker/enhance_profile_job_test_user_not_found") do
      @speaker = Speaker.create!(name: "Nathan Bibler")
      Speaker::EnhanceProfileJob.new.perform(@speaker)
      assert_equal "", @speaker.reload.github
    end
  end

  test "search Hampton Catlin" do
    VCR.use_cassette("speaker/enhance_profile_job_test_search_hampton_catlin") do
      @speaker = Speaker.create!(name: "Hampton Catlin")
      Speaker::EnhanceProfileJob.new.perform(@speaker)
      assert_equal "HamptonMakes", @speaker.reload.github
    end
  end

  test "search Design a user with no name" do
    VCR.use_cassette("speaker/enhance_profile_job_test_search_design") do
      @speaker = Speaker.create!(name: "Design")
      Speaker::EnhanceProfileJob.new.perform(@speaker)
      assert_equal "design", @speaker.reload.github
    end
  end
end
