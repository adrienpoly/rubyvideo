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
  # test "the truth" do
  #   assert true
  # end
end
