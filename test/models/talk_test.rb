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

  test "should guess kind from title" do
    kind_with_titles = {
      talk: ["I love Ruby"],
      keynote: ["Keynote: Something ", "foo Opening keynote bar", "closing keynote foo bar", "Keynote", "Keynote by Someone", "Opening Keynote", "Closing Keynote"],
      lightning_talk: ["Lightning Talk: Something", "lightning talk: Something", "Lightning talk: Something", "lightning talk", "Lightning Talks", "Lightning talks", "lightning talks", "Lightning Talks Day 1", "Lightning Talks (Day 1)", "Lightning Talks - Day 1", "Micro Talk: Something", "micro talk: Something", "micro talk: Something", "micro talk"],
      panel: ["Panel: foo", "Panel", "Something Panel"],
      workshop: ["Workshop: Something", "workshop: Something"],
      gameshow: ["Gameshow", "Game Show", "Gameshow: Something", "Game Show: Something"],
      podcast: ["Podcast: Something", "Podcast Recording: Something", "Live Podcast: Something"],
      q_and_a: ["Q&A", "Q&A: Something", "Something AMA", "Q&A with Somebody", "Ruby Committers vs The World", "Ruby Committers and the World"],
      discussion: ["Discussion: Something", "Discussion", "Fishbowl: Topic", "Fishbowl Discussion: Topic"],
      fireside_chat: ["Fireside Chat: Something", "Fireside Chat"],
      interview: ["Interview with Matz", "Interview: Something"],
      award: ["Award: Something", "Award Show", "Ruby Hero Awards", "Ruby Hero Award", "Rails Luminary"]
    }

    kind_with_titles.each do |kind, titles|
      titles.each do |title|
        talk = Talk.new(title:)
        talk.save!

        assert_equal kind.to_s, talk.kind

        talk.destroy!
      end
    end
  end

  test "should not guess a kind if it's provided" do
    talk = Talk.create!(title: "foo", kind: "panel")

    assert_equal "panel", talk.kind
  end

  test "should not guess a kind if it's provided in the static metadata" do
    talk = Talk.create!(
      title: "Who Wants to be a Ruby Engineer?",
      video_provider: "mp4",
      video_id: "https://videos.brightonruby.com/videos/2024/drew-bragg-who-wants-to-be-a-ruby-engineer.mp4"
    )

    assert_equal "gameshow", talk.kind
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
    @talk = Talk.includes(event: :organisation).find(@talk.id)

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

  test "full text search on title" do
    @talk = talks(:one)
    assert_equal [@talk], Talk.ft_search("Hotwire Cookbook")
    assert_equal [@talk], Talk.ft_search("Hotwire Cookbook: Common Uses, Essential Patterns")
    assert_equal [@talk], Talk.ft_search('Hotwire"') # with an escaped quote
  end

  test "full text search on title with snippets" do
    @talk = talks(:one)
    assert_equal [@talk], Talk.ft_search("Hotwire Cookbook").with_snippets
    first_result = Talk.ft_search("Hotwire Cookbook").with_snippets.first
    assert_equal "<mark>Hotwire</mark> <mark>Cookbook</mark>: Common Uses, Essential Patterns & Best Practices",
      first_result.title_snippet
  end

  test "full text search on summary" do
    @talk = talks(:one)
    @talk.update! summary: <<~HEREDOC
      Do ad cupidatat aliqua magna incididunt Lorem cillum velit voluptate duis dolore magna.
      Veniam aute labore non excepteur id pariatur ut exercitation labore.
      Dolor eu amet cupidatat dolore nisi nostrud elit tempor officia.
      Cupidatat exercitation voluptate esse officia tempor anim tempor adipisicing adipisicing commodo sint.
      In ea adipisicing dolore esse dolor velit nulla enim mollit est velit laboris laborum.
      Dolor ea non voluptate et et excepteur laborum tempor.
    HEREDOC

    assert_equal [@talk], Talk.ft_search("incididunt")
    assert_equal [@talk], Talk.ft_search("incid*")
  end

  test "full text search on summary with snippets" do
    @talk = talks(:one)
    @talk.update! summary: <<~HEREDOC
      Do ad cupidatat aliqua magna incididunt Lorem cillum velit voluptate duis dolore magna.
      Veniam aute labore non excepteur id pariatur ut exercitation labore.
      Dolor eu amet cupidatat dolore nisi nostrud elit tempor officia.
      Cupidatat exercitation voluptate esse officia tempor anim tempor adipisicing adipisicing commodo sint.
      In ea adipisicing dolore esse dolor velit nulla enim mollit est velit laboris laborum.
      Dolor ea non voluptate et et excepteur laborum tempor.
    HEREDOC

    assert_equal [@talk], Talk.ft_search("incididunt").with_snippets
    first_result = Talk.ft_search("incididunt").with_snippets.first
    assert_match "<mark>incididunt</mark>", first_result.summary_snippet
  end

  test "mark talk as watched" do
    talk = talks(:two)
    Current.user = users(:one)

    assert_equal 0, talk.watched_talks.count

    talk.mark_as_watched!

    assert_equal 1, talk.watched_talks.count
    assert talk.watched?
  end

  test "unmark talk as watched" do
    watched_talk = watched_talks(:one)
    talk = watched_talk.talk
    Current.user = users(:one)

    talk.unmark_as_watched!

    assert_equal 0, talk.watched_talks.count
    assert_not talk.watched?
  end

  test "should return a valid youtube thumbnail url" do
    talk = talks(:one)

    assert_match %r{^https://i.ytimg.com/vi/.*/sddefault.jpg$}, talk.thumbnail
  end

  test "should return a specific size youtube thumbnail url" do
    talk = talks(:one)

    assert_match %r{^https://i.ytimg.com/vi/.*/maxresdefault.jpg$}, talk.thumbnail(:thumbnail_xl)
  end

  test "should return the event thumbnail for non youtube talks" do
    talk = talks(:brightonruby_2024_one).tap do |t|
      ActiveRecord::Associations::Preloader.new(records: [t], associations: [event: :organisation]).call
    end

    assert_match %r{^/assets/events/brightonruby/brightonruby-2024/poster-.*.webp$}, talk.thumbnail
    assert_match %r{^/assets/events/brightonruby/brightonruby-2024/poster-.*.webp$}, talk.thumbnail(:thumbnail_xl)
  end

  test "for_topic" do
    talk = talks(:one)
    assert_includes Talk.for_topic("activerecord"), talk
  end
end
