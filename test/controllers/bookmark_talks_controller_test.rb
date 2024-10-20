require "test_helper"

class BookmarkTalksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @watch_list = @user.default_watch_list
    @talk = talks(:one)
    sign_in_as @user
  end

  test "should bookmark talk to default watch list" do
    assert_difference("WatchListTalk.count") do
      post bookmark_talks_url params: {talk_id: @talk.id}
    end

    assert_redirected_to watch_list_url(@watch_list)
    assert_includes @watch_list.talks, @talk
  end

  test "should remove talk from watch_list" do
    WatchListTalk.create!(watch_list: @watch_list, talk: @talk)

    assert_difference("WatchListTalk.count", -1) do
      delete bookmark_talk_url(@talk.id)
    end

    assert_redirected_to watch_list_url(@watch_list)
    assert_not_includes @watch_list.talks, @talk
  end
end
