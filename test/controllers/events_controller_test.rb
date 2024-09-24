require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:railsconf_2017)
    @user = users(:lazaro_nixon)
  end

  test "should get index" do
    get events_url
    assert_response :success
    assert_select ".title", text: "Events"
    assert_select "##{dom_id(@event)}", 1
  end

  test "should get index and return events in the correct order" do
    event_names = %i[rails_world_2023 tropical_rb_2024 railsconf_2017 rubyconfth_2022].map { |event| events(event) }.map(&:name)

    get events_url

    assert_response :success

    assert_select ".event .event-name", count: event_names.size do |nodes|
      assert_equal event_names, nodes.map(&:text)
    end
  end

  test "should get index search result" do
    get events_url(letter: "T")
    assert_response :success
    assert_select "span", text: "Tropical Ruby 2024"
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  test "should redirect to canonical event" do
    @talk = talks(:one)
    @talk.update(event: @event)
    canonical_event = events(:rubyconfth_2022)
    @event.assign_canonical_event!(canonical_event: canonical_event)
    get event_url(@event)

    assert_redirected_to event_url(canonical_event)
  end

  test "should get edit" do
    sign_in_as @user
    get edit_event_url(@event)
    assert_response :success
  end

  test "should create a pending suggestion for anonymous users" do
    assert_difference "Suggestion.pending.count", 1 do
      patch event_url(@event), params: {event: {city: "Paris", country_code: "FR"}}
    end

    assert_redirected_to event_url(@event)
  end

  test "should create a pending suggestion for signed in users" do
    sign_in_as @user

    assert_difference "Suggestion.pending.count", 1 do
      patch event_url(@event), params: {event: {city: "Paris", country_code: "FR"}}
    end

    assert_redirected_to event_url(@event)
  end

  test "should update directly the content for admins" do
    sign_in_as users(:admin)
    assert_difference "Suggestion.approved.count", 1 do
      patch event_url(@event), params: {event: {city: "Paris", country_code: "FR"}}
    end

    assert_equal "Paris", @event.reload.city
    assert_equal "FR", @event.reload.country_code
    assert_redirected_to event_url(@event)
  end

  test "should display an empty state message when no events are found" do
    Event.delete_all

    get events_url

    assert_response :success
    assert_select "p", text: "No events found"
  end
end
