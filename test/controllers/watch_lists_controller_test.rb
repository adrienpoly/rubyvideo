require "test_helper"

class WatchListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @watch_list = watch_lists(:one)
    sign_in_as @user
  end

  test "should get index" do
    get watch_lists_url
    assert_response :success
  end

  test "should get new" do
    get new_watch_list_url
    assert_response :success
  end

  test "should create watch_list" do
    assert_difference("WatchList.count") do
      post watch_lists_url, params: {watch_list: {name: "New WatchList", description: "Description"}}
    end

    assert_redirected_to watch_list_url(WatchList.last)
  end

  test "should show watch_list" do
    get watch_list_url(@watch_list)
    assert_response :success
  end

  test "should get edit" do
    get edit_watch_list_url(@watch_list)
    assert_response :success
  end

  test "should update watch_list" do
    patch watch_list_url(@watch_list), params: {watch_list: {name: "Updated WatchList"}}
    assert_redirected_to watch_list_url(@watch_list)
    @watch_list.reload
    assert_equal "Updated WatchList", @watch_list.name
  end

  test "should destroy watch_list" do
    assert_difference("WatchList.count", -1) do
      delete watch_list_url(@watch_list)
    end

    assert_redirected_to watch_lists_url
  end
end
