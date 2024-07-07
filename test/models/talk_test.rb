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
  test "should serialize and deserialize transcript correctly" do
    vtt_string = <<~VTT
      WEBVTT

      00:00.000 --> 00:05.000
      Welcome to the talk.

      00:06.000 --> 00:10.000
      Let's get started.
    VTT

    talk = Talk.new(title: "Sample Talk", transcript: vtt_string)
    assert talk.save

    loaded_talk = Talk.find(talk.id)
    assert_equal WebVTTSerializer.load(vtt_string), loaded_talk.transcript
  end

  test "should convert transcript to WebVTT format correctly" do
    vtt_string = <<~VTT
      WEBVTT

      00:00.000 --> 00:05.000
      Welcome to the talk.

      00:06.000 --> 00:10.000
      Let's get started.
    VTT

    cues = WebVTTSerializer.load(vtt_string)
    talk = Talk.new(title: "Sample Talk", transcript: cues)

    expected_vtt = WebVTTSerializer.dump(talk.transcript)
    assert_equal vtt_string.strip, expected_vtt.strip
  end

  test "should handle empty transcript" do
    talk = Talk.new(title: "Sample Talk", transcript: [])
    assert talk.save

    loaded_talk = Talk.find(talk.id)
    assert_empty loaded_talk.transcript
  end

  test "should update transcript" do
    @talk = talks(:one)

    VCR.use_cassette("youtube/transcript") do
      perform_enqueued_jobs do
        @talk.update_transcript!
      end
    end

    assert_not_empty @talk.transcript
    assert @talk.transcript.length > 100
  end
end
