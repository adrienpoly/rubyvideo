require "application_system_test_case"

class SpeakersTest < ApplicationSystemTestCase
  setup do
    @speaker = speakers(:one)
  end

  test "should update Speaker" do
    visit speaker_url(@speaker)
    click_on "Edit", match: :first

    assert_text "Editing speaker"

    fill_in "Bio", with: @speaker.bio
    fill_in "Github", with: @speaker.github
    fill_in "Name", with: @speaker.name
    fill_in "Slug", with: @speaker.slug
    fill_in "Twitter", with: @speaker.twitter
    fill_in "Website", with: @speaker.website
    click_on "Suggest modifications"

    assert_text "Your suggestion was successfully created and will be reviewed soon."
  end
end
