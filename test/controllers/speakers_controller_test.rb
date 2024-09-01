require "test_helper"

class SpeakersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @speaker = speakers.one
    @speaker_with_talk = speakers.two

    @speaker_with_talk.talks << talks.one
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

  test "should redirect to canonical speaker" do
    talk = @speaker_with_talk.talks.first
    @speaker_with_talk.assign_canonical_speaker!(canonical_speaker: @speaker)
    @speaker_with_talk.reload
    assert_equal @speaker, @speaker_with_talk.canonical
    assert @speaker.talks.ids.include?(talk.id)
    assert @speaker_with_talk.talks.empty?

    get speaker_url(@speaker_with_talk)
    assert_redirected_to speaker_url(@speaker)
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
