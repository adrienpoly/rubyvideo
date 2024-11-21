require "test_helper"

class Spotlight::EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organisation = organisations(:railsconf)
    @event = events(:railsconf_2017)
  end

  test "should get index with turbo stream format" do
    get spotlight_events_url(format: :turbo_stream)
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", @response.media_type
  end

  test "should get index with search query" do
    get spotlight_events_url(format: :turbo_stream, s: @event.name)
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", @response.media_type
    assert_equal @event.id, assigns(:events).first.id
  end

  test "should limit results to 5 talks" do
    6.times { |i| Event.create!(name: "Event #{i}", organisation: @organisation) }

    get spotlight_events_url(format: :turbo_stream)
    assert_response :success
    assert_equal 5, assigns(:events).size
    assert_equal Event.all.count, assigns(:events_count)
  end

  test "should not track analytics" do
    assert_no_difference "Ahoy::Event.count" do
      with_event_tracking do
        get spotlight_events_url(format: :turbo_stream)
        assert_response :success
      end
    end
  end
end
