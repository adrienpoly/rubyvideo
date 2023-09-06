require "test_helper"

class PageControllerTest < ActionDispatch::IntegrationTest
  test "should get home page" do
    get root_path
    assert_response :success
  end

  test "should get uses page" do
    get uses_path
    assert_response :success
  end
end
