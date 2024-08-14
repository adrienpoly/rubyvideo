# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: talks
#
#  id                  :integer          not null, primary key
#  title               :string           default(""), not null
#  description         :text             default(""), not null
#  slug                :string           default(""), not null
#  video_id            :string           default(""), not null
#  video_provider      :string           default(""), not null
#  thumbnail_sm        :string           default(""), not null
#  thumbnail_md        :string           default(""), not null
#  thumbnail_lg        :string           default(""), not null
#  year                :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  event_id            :integer
#  thumbnail_xs        :string           default(""), not null
#  thumbnail_xl        :string           default(""), not null
#  date                :date
#  like_count          :integer
#  view_count          :integer
#  raw_transcript      :text             default(""), not null
#  enhanced_transcript :text             default(""), not null
#  summary             :text             default(""), not null
#
# rubocop:enable Layout/LineLength
require "test_helper"

class TalkTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  test "should handle empty transcript" do
    talk = Talk.new(title: "Sample Talk", raw_transcript: Transcript.new)
    assert talk.save

    loaded_talk = Talk.find(talk.id)
    assert_equal loaded_talk.transcript.cues, []
    assert_equal "Sample Talk", loaded_talk.title
  end

  test "should update transcript" do
    @talk = talks(:one)

    VCR.use_cassette("youtube/transcript") do
      perform_enqueued_jobs do
        @talk.fetch_and_update_raw_transcript!
      end
    end

    assert @talk.transcript.is_a?(Transcript)
    assert @talk.transcript.cues.first.is_a?(Cue)
    assert @talk.transcript.cues.length > 100
  end

  test "transcript should default to raw_transcript" do
    raw_transcript = Transcript.new(cues: [Cue.new(start_time: 0, end_time: 1, text: "Hello")])
    talk = Talk.new(title: "Sample Talk", raw_transcript: raw_transcript)
    assert talk.save

    loaded_talk = Talk.find(talk.id)
    assert_equal loaded_talk.transcript.cues.first.text, "Hello"
  end

  test "talks one has a valid transcript" do
    talk = talks(:one)
    assert talk.transcript.is_a?(Transcript)
    assert talk.transcript.cues.first.is_a?(Cue)
  end

  test "enhance talk transcript" do
    @talk = talks(:one)

    refute @talk.enhanced_transcript.cues.present?
    VCR.use_cassette("talks/transcript-enhancement") do
      assert_changes "@talk.transcript.cues" do
        perform_enqueued_jobs do
          @talk.enhance_transcript!
        end
      end
      assert @talk.enhanced_transcript.cues.present?
    end
  end

  test "extract topics" do
    @talk = talks(:one)

    VCR.use_cassette("talks/extract_topics") do
      assert_changes "@talk.topics.count" do
        perform_enqueued_jobs do
          AnalyzeTalkTopicsJob.perform_later(@talk)
        end
      end
    end

    puts @talk.topics.pluck(:name)
  end
end
