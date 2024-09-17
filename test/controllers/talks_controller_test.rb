require "test_helper"

class TalksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @talk = talks(:one)
  end

  test "should get index" do
    get talks_url
    assert_response :success
  end

  test "should show talk" do
    get talk_url(@talk)
    assert_response :success
  end

  test "should redirect to talks for wrong slugs" do
    get talk_url("wrong-slug")
    assert_response :moved_permanently
  end

  test "should get edit" do
    get edit_talk_url(@talk)
    assert_response :success
  end

  test "anonymous user can suggest a modification" do
    patch talk_url(@talk), params: {talk: {description: "new description", slug: "new-slug", title: "new title", date: "2024-01-01"}}
    assert_redirected_to talk_url(@talk)
    assert_equal "Your suggestion was successfully created and will be reviewed soon.", flash[:notice]
    assert_equal 1, @talk.suggestions.pending.count
    assert_not_equal "new description", @talk.reload.description
    assert_not_equal "new title", @talk.title
    assert_not_equal "2024-01-01", @talk.date.to_s
  end

  test "admin user can update talk" do
    @user = users(:admin)
    sign_in_as @user

    patch talk_url(@talk), params: {talk: {summary: "new summary", description: "new description", slug: "new-slug", title: "new title", date: "2024-01-01"}}
    assert_redirected_to talk_url(@talk)
    assert_equal "Modification approved!", flash[:notice]
    assert_equal 1, @talk.suggestions.approved.count
    assert_equal "new description", @talk.reload.description
    assert_equal "new summary", @talk.summary
    assert_equal "new title", @talk.title
    assert_equal "2024-01-01", @talk.date.to_s

    # some attributes cannot be changed
    assert_not_equal "new slug", @talk.slug
  end

  test "owner can update directly the talk" do
    user = User.create!(email: "test@example.com", password: "Secret1*3*5*", github_handle: @talk.speakers.first.github, verified: true)
    assert user.persisted?
    assert_equal user, @talk.speakers.first.user

    sign_in_as user

    patch talk_url(@talk), params: {talk: {summary: "new summary", description: "new description", slug: "new-slug", title: "new title", date: "2024-01-01"}}
    assert_redirected_to talk_url(@talk)
    assert_equal "Modification approved!", flash[:notice]
    assert_equal 1, @talk.suggestions.approved.count
    assert_equal "new description", @talk.reload.description
    assert_equal "new summary", @talk.summary
    assert_equal "new title", @talk.title
    assert_equal "2024-01-01", @talk.date.to_s

    # some attributes cannot be changed
    assert_not_equal "new slug", @talk.slug
  end

  test "should show topics" do
    # to remove when we remove the poor man FF for the topics
    @user = users(:admin)
    sign_in_as @user

    get talk_url(@talk)
    assert_select "a .badge", count: 1, text: "#activerecord"
    assert_select "a .badge", count: 0, text: "#rejected"
  end
end
