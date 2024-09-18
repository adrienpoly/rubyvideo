# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: suggestions
#
#  id               :integer          not null, primary key
#  content          :text
#  status           :integer          default("pending"), not null
#  suggestable_type :string           not null
#  suggestable_id   :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  approved_by_id   :integer
#  suggested_by_id  :integer
#
# rubocop:enable Layout/LineLength
require "test_helper"

class SuggestionTest < ActiveSupport::TestCase
  setup do
    @talk = talks(:one)
  end

  test "serialize the content" do
    suggestion = Suggestion.create!(content: {title: "Hello World"}, suggestable: @talk)

    assert suggestion.persisted?
    assert suggestion[:content].is_a?(Hash)
  end

  test "approve the suggestion" do
    suggestion = Suggestion.create!(content: {title: "Hello World"}, suggestable: @talk)

    assert suggestion.pending?

    suggestion.approved!(approver: users(:one))

    assert suggestion.approved?
    assert_equal "Hello World", @talk.reload.title
  end
end
