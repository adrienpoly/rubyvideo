require "test_helper"

class Speakers::EnhanceControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:admin))
  end

  test "#patch" do
    patch speakers_enhance_url(speakers(:one), {format: :turbo_stream})
    assert_response :success
  end
end
