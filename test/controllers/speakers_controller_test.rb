require "test_helper"

class SpeakersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @speaker = speakers(:one)
  end

  test "should get index" do
    get speakers_url
    assert_response :success
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
    assert_includes json_response["speakers"].map { |speaker_data| speaker_data["name"] }, @speaker.name
  end
end
