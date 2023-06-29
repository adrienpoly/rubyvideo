require "application_system_test_case"

class TalksTest < ApplicationSystemTestCase
  setup do
    @talk = talks(:one)
  end

  test "visiting the index" do
    visit talks_url
    assert_selector "h1", text: "Talks"
  end

  test "should update Talk" do
    visit talk_url(@talk)
    click_on "Edit", match: :first

    fill_in "Description", with: @talk.description
    fill_in "Title", with: @talk.title
    fill_in "Year", with: @talk.year
    click_on "Suggest modifications"

    assert_text "Your suggestion was successfully created and will be reviewed soon."
  end
end
