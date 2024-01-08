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

  test "should update talk" do
    patch talk_url(@talk), params: {talk: {description: @talk.description, slug: @talk.slug, title: @talk.title, year: @talk.year}}
    assert_redirected_to talk_url(@talk)
  end

  test "should perform search and return turbo_stream" do
    get search_talks_url, params: {q: "rails", years: ["2020"], event_ids: ["1"]}
    assert_response :success
    assert_match(/turbo-stream/i, response.body)
  end
end
