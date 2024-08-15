require "test_helper"

class SpeakersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @speaker = speakers(:one)
    @speaker_with_talk = speakers(:two)

    @speaker_with_talk.talks << talks(:one)
  end

  test "should get index" do
    get speakers_url
    assert_response :success

    assert_select "##{dom_id(@speaker)}", 0
    assert_select "##{dom_id(@speaker_with_talk)}", 1
  end

  test "should show speaker" do
    get speaker_url(@speaker)
    assert_response :success
  end

  test "should get edit" do
    get edit_speaker_url(@speaker)
    assert_response :success
  end

  test "should update speaker" do
    patch speaker_url(@speaker), params: {speaker: {bio: @speaker.bio, github: @speaker.github, name: @speaker.name, slug: @speaker.slug, twitter: @speaker.twitter, website: @speaker.website}}
    assert_redirected_to speaker_url(@speaker)
  end

  test "should get index as JSON" do
    get speakers_url, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    speakers = json_response["speakers"].map { |speaker_data| speaker_data["name"] }

    assert_includes speakers, @speaker_with_talk.name
    assert_equal 1, speakers.length
  end
end
