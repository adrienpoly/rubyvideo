require "test_helper"

class TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activesupport = topics(:activesupport)

    @activerecord = topics(:activerecord)
    @activerecord.update(published: true)
    @talk = talks(:one)
    @activerecord.talks << @talk
  end

  test "should get index" do
    get topics_url
    assert_response :success

    assert_select "h1", "Topics"

    assert_select "##{dom_id(@activerecord)} > span", "1"
    assert_select "##{dom_id(@activesupport)}", 0

    @activesupport.update(published: true)
    assert_select "##{dom_id(@activesupport)}", 0
  end

  test "should get show" do
    get topic_url(@activerecord)
    assert_response :success
    assert_select "h1", @activerecord.name
    assert_select "#topic-talks > div", 1
    assert_select "##{dom_id(@talk)} h2", @talk.title

    get topic_url(@activesupport)
    assert_response :success
    assert_select "h1", @activesupport.name
    assert_select "#topic-talks > div", 0
  end
end
