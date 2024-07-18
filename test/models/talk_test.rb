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
#  raw_transcript      :text
#  enhanced_transcript :text             default(#<Transcript:0x000000017393e0d0 @cues=[]>), not null
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

  test "enhance talk transcript" do
    @talk = talks(:one)
    transcript = Transcript.new
    # standard:disable Layout/LineLength
    cues_data = [
      ["00:00:15.280", "00:00:21.320", "so nice to be here with you thank you all for coming so uh my name is uh"],
      ["00:00:21.320", "00:00:27.800", "yaroslav I'm from Ukraine you might know me from my blog or from my super Al"],
      ["00:00:27.800", "00:00:34.399",
        "YouTube channel where I post a lot of stuff about trby and especially about hot fire so I originate from Ukraine"],
      ["00:00:34.399", "00:00:40.239",
        "from the north of Ukraine so right now it is liberated so that is Kev Chernobyl"],
      ["00:00:40.239", "00:00:45.920", "and chern so I used to live 80 kmers away from Chernobyl great"],
      ["00:00:45.920", "00:00:52.680",
        "place yeah and uh that is my family's home so it got boned in one of the first"],
      ["00:00:52.680", "00:01:00.000",
        "days of war that is my godfather he went to defend Ukraine and uh I mean we are"],
      ["00:01:00.000", "00:01:05.799",
        "he has such a beautiful venue but there is the war going on and like just today"],
      ["00:01:05.799", "00:01:13.159", "the city of har was randomly boned by the Russians and there are many Ruby"],
      ["00:01:13.159", "00:01:19.520",
        "rails people from Ukraine some of them are actually fighting this is verok he contributed to Ruby and he is actually"],
      ["00:01:19.520", "00:01:27.960",
        "defending Ukraine right now but on a positive note I just recently became a father"],
      ["00:01:27.960", "00:01:35.000", "so yeah um it is uh just 2 and a half months ago in uh France and uh today we"],
      ["00:01:35.000", nil, "are going to talk about hot fire"]
    ]
    # standard:enable Layout/LineLength

    cues_data.each do |start_time, end_time, text|
      end_time ||= start_time # If end_time is nil, set it to the same as start_time
      transcript.add_cue(Cue.new(start_time: start_time, end_time: end_time, text: text))
    end
    @talk.update(raw_transcript: transcript)

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
end
