# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  verified        :boolean          default(FALSE), not null
#  admin           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string
#  github_handle   :string
#
# rubocop:enable Layout/LineLength
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
