require "test_helper"

class Speakers::EnhanceControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:admin))
  end

  test "#patch" do
    speaker = speakers(:one)

    assert_nil speaker.github_metadata.dig("profile", "login")

    VCR.use_cassette("speakers/enhance_controller_test/patch") do
      patch speakers_enhance_url(speaker, {format: :turbo_stream})
      assert_response :success
    end

    speaker.reload

    assert_equal "obie", speaker.github_metadata.dig("profile", "login")
  end
end
