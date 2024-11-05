# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  date            :date
#  city            :string
#  country_code    :string
#  organisation_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string           default(""), not null
#  slug            :string           default(""), not null
#  talks_count     :integer          default(0), not null
#  canonical_id    :integer
#
# rubocop:enable Layout/LineLength
require "test_helper"

class EventTest < ActiveSupport::TestCase
  setup do
    @organisation = organisations(:railsconf)
    @organisation.update(website: "https://railsconf.org")
  end

  test "validates the country code " do
    assert Event.new(name: "test", country_code: "NL", organisation: @organisation).valid?
    assert Event.new(name: "test", country_code: "AU", organisation: @organisation).valid?
    refute Event.new(name: "test", country_code: "France", organisation: @organisation).valid?
  end

  test "allows nil country code" do
    assert Event.new(name: "test", country_code: nil, organisation: @organisation).valid?
  end


  test "returns event website if present" do
    event = Event.new(name: "test", organisation: @organisation, website: "https://event-website.com")
    assert_equal "https://event-website.com", event.website
  end

  test "returns organisation website if event website is not present" do
    event = Event.new(name: "test", organisation: @organisation, website: nil)
    assert_equal "https://railsconf.org", event.website
  end
end