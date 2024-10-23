# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: talk_topics
#
#  id         :integer          not null, primary key
#  talk_id    :integer          not null
#  topic_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# rubocop:enable Layout/LineLength
require "test_helper"

class TalkTopicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
