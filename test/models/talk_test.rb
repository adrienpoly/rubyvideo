# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: talks
#
#  id             :integer          not null, primary key
#  title          :string           default(""), not null
#  description    :text             default(""), not null
#  slug           :string           default(""), not null
#  video_id       :string           default(""), not null
#  video_provider :string           default(""), not null
#  thumbnail_sm   :string           default(""), not null
#  thumbnail_md   :string           default(""), not null
#  thumbnail_lg   :string           default(""), not null
#  year           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  event_id       :integer
#  thumbnail_xs   :string           default(""), not null
#  thumbnail_xl   :string           default(""), not null
#  date           :date
#  like_count     :integer
#  view_count     :integer
#
# rubocop:enable Layout/LineLength
require "test_helper"

class TalkTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  test "should handle empty transcript" do
    talk = Talk.new(title: "Sample Talk", transcript: Transcript.new)
    assert talk.save

    loaded_talk = Talk.find(talk.id)
    assert_equal loaded_talk.transcript.cues, []
    assert_equal "Sample Talk", loaded_talk.title
  end

  test "should update transcript" do
    @talk = talks(:one)

    VCR.use_cassette("youtube/transcript") do
      perform_enqueued_jobs do
        @talk.update_transcript!
      end
    end

    assert @talk.transcript.is_a?(Transcript)
    assert @talk.transcript.cues.first.is_a?(Cue)
    assert @talk.transcript.cues.length > 100
  end
end
