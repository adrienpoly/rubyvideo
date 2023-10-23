require "test_helper"

class Talks::RecommendationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @talk = talks(:one)
  end

  test "should get index" do
    get talk_recommendations_url(@talk)
    assert_response :success
    assert_equal assigns(:talk).id, @talk.id
    assert_not_nil assigns(:talks)
  end
end
