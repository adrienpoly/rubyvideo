require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events.one
    @user = users.lazaro_nixon
  end

  test "should get index" do
    get events_url
    assert_response :success
    assert_select ".title", text: "Events"
    assert_select "##{dom_id(@event)}", 1
  end

  test "should get index and return events in the correct order" do
    @events = [events.one, events.rails_world_2023, events.two]

    get events_url
    assert_response :success

    assert_select ".event .event-name", count: 3 do |nodes|
      assert_equal @events.map(&:name), nodes.map(&:text)
    end
  end

  test "should get index search result" do
    get events_url(letter: "T")
    assert_response :success
    assert_select "span", text: "Tropical Ruby"
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
    patch event_url(@event), params: {event: {city: "Paris", country_code: "FR"}}
    assert_redirected_to event_url(@event)
  end
end
