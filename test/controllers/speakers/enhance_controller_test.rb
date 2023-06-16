require "test_helper"

class Speakers::EnhanceControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get speakers_enhance_update_url
    assert_response :success
  end
end
