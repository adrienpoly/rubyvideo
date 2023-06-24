require "test_helper"

class Analytics::DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get analytics_dashboards_path
    assert_response :success
  end
end
