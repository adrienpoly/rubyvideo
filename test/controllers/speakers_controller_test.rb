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

  test "should create a suggestion for speaker" do
    patch speaker_url(@speaker), params: {speaker: {bio: "new bio", github: "new-github", name: "new-name", slug: "new-slug", twitter: "new-twitter", website: "new-website"}}

    assert_redirected_to speaker_url(@speaker)
    assert_not_equal @speaker.reload.bio, "new bio"
    assert_equal 1, @speaker.suggestions.pending.count
  end

  test "admin can update directly the speaker" do
    sign_in_as users(:admin)
    patch speaker_url(@speaker), params: {speaker: {bio: "new bio", github: "new-github", name: "new-name", slug: "new-slug", twitter: "new-twitter", website: "new-website"}}

    assert_redirected_to speaker_url(@speaker)
    assert_equal "new bio", @speaker.reload.bio
    assert_equal 0, @speaker.suggestions.pending.count
    assert_equal users(:admin).id, @speaker.suggestions.last.suggested_by_id
  end

  test "owner can update directly the speaker" do
    user = User.create!(email: "test@example.com", password: "Secret1*3*5*", github_handle: @speaker.github, verified: true)
    assert user.persisted?
    assert_equal user, @speaker.user

    sign_in_as user

    assert_no_changes -> { @speaker.suggestions.pending.count } do
      patch speaker_url(@speaker), params: {speaker: {bio: "new bio", github: "new-github", name: "new-name", slug: "new-slug", twitter: "new-twitter", website: "new-website"}}
    end

    assert_redirected_to speaker_url(@speaker)
    assert_equal "new bio", @speaker.reload.bio
    assert_equal @speaker.name, "new-name"
    assert_equal @speaker.twitter, "new-twitter"
    assert_equal @speaker.website, "new-website"
    assert_equal user.id, @speaker.suggestions.last.suggested_by_id

    # those attributes can't be changed by the owner
    assert_not_equal @speaker.github, "new-github"
    assert_not_equal @speaker.slug, "new-slug"
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
