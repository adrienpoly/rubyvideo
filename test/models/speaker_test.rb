# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: speakers
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  twitter     :string           default(""), not null
#  github      :string           default(""), not null
#  bio         :text             default(""), not null
#  website     :string           default(""), not null
#  slug        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  talks_count :integer          default(0), not null
#
# rubocop:enable Layout/LineLength
require "test_helper"

class SpeakerTest < ActiveSupport::TestCase
  test "valid_website_url preserve the website url if already valid" do
    speaker = Speaker.new(website: "https://www.google.com")
    assert_equal "https://www.google.com", speaker.valid_website_url
  end

  test "valid_website_url add https to the website if it is not present" do
    speaker = Speaker.new(website: "www.google.com")
    assert_equal "https://www.google.com", speaker.valid_website_url
  end

  test "valid_website_url convert http to https" do
    speaker = Speaker.new(website: "http://www.google.com")
    assert_equal "https://www.google.com", speaker.valid_website_url
  end

  test "valid_website_url returns # if website is blank" do
    speaker = Speaker.new(website: "")
    assert_equal "#", speaker.valid_website_url
  end
end
