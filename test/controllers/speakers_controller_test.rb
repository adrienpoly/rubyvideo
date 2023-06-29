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
end
