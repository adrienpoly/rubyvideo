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

    File.write("response.html", response.body.to_s)

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

  test "should update event" do
    patch event_url(@event), params: {event: {city: "Paris", country_code: "FR"}}
    assert_redirected_to event_url(@event)
  end
end
