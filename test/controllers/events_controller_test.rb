require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
    @user = users(:lazaro_nixon)
  end

  test "should get index" do
    get events_url
    assert_response :success
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  test "should get edit" do
    sign_in_as @user
    get edit_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    sign_in_as @user
    patch event_url(@event), params: {event: {description: @event.description, frequency: @event.frequency, kind: @event.kind, name: @event.name, website: @event.website}}
    assert_redirected_to event_url(@event)
  end
end
