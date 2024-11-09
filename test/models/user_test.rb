require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should normalize github_handle by stripping URL, www, and @" do
    user = users(:one)

    user.github_handle = "Https://www.github.com/tekin"
    user.save
    assert_equal "tekin", user.github_handle

    user.github_handle = "github.com/tekin"
    user.save
    assert_equal "tekin", user.github_handle

    user.github_handle = "@tekin"
    user.save
    assert_equal "tekin", user.github_handle
  end
end
