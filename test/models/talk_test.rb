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
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  event_id            :integer
#  thumbnail_xs        :string           default(""), not null
#  thumbnail_xl        :string           default(""), not null
#  date                :date
#  like_count          :integer
#  view_count          :integer
#  raw_transcript      :text             default(#<Transcript:0x00000001645d16b8 @cues=[]>), not null
#  enhanced_transcript :text             default(#<Transcript:0x00000001645d15c8 @cues=[]>), not null
#  summary             :text             default(""), not null
#  language            :string           default("en"), not null
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
  end

  test "does not create duplicate topics" do
    @talk = talks(:one)
    perform_enqueued_jobs do
      VCR.use_cassette("talks/extract_topics", allow_playback_repeats: true) do
        AnalyzeTalkTopicsJob.perform_later(@talk)
        assert_no_changes "@talk.topics.count" do
          AnalyzeTalkTopicsJob.perform_later(@talk)
        end
      end
    end
  end

  test "update_from_yml_metadata" do
    @talk = talks(:one)
    @event = events(:rails_world_2023)
    @talk.update!(title: "New title", description: "New description", event: @event)

    assert_equal "New title", @talk.title
    assert_equal "New description", @talk.description

    @talk.update_from_yml_metadata!

    assert_equal "Hotwire Cookbook: Common Uses, Essential Patterns & Best Practices", @talk.title
  end

  test "language is english by default" do
    assert_equal "en", Talk.new.language
  end

  test "language is normalized to alpha2 code" do
    assert_equal "en", Talk.new(language: "English").language
    assert_equal "en", Talk.new(language: "english").language
    assert_equal "en", Talk.new(language: "en").language

    assert_equal "ja", Talk.new(language: "Japanese").language
    assert_equal "ja", Talk.new(language: "japanese").language
    assert_equal "ja", Talk.new(language: "ja").language

    assert_nil Talk.new(language: "doesntexist").language
    assert_nil Talk.new(language: "random").language
  end

  test "language must be valid and present" do
    talk = talks(:one)
    talk.language = "random"
    talk.valid?

    assert_equal 2, talk.errors.size
    assert_equal ["Language can't be blank", "Language  is not a valid IS0-639 alpha2 code"],
      talk.errors.map(&:full_message)
  end

  test "create a new talk with a nil language" do
    talk = Talk.create!(title: "New title", language: nil)
    assert_equal "en", talk.language
    assert talk.valid?
  end
end
