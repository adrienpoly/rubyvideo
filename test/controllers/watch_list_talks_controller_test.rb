require "test_helper"

class WatchListTalksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @watch_list = watch_lists(:one)
    @talk = talks(:one)
    sign_in_as @user
  end

  test "should add talk to watch_list" do
    assert_difference("WatchListTalk.count") do
      post watch_list_talks_url(@watch_list), params: {talk_id: @talk.id}
    end

    assert_redirected_to watch_list_url(@watch_list)
    assert_includes @watch_list.talks, @talk
  end

  test "should remove talk from watch_list" do
    WatchListTalk.create!(watch_list: @watch_list, talk: @talk)

    assert_difference("WatchListTalk.count", -1) do
      delete watch_list_talk_url(@watch_list, @talk.id)
    end

    assert_redirected_to watch_list_url(@watch_list)
    assert_not_includes @watch_list.talks, @talk
  end
end
