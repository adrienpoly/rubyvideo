require "test_helper"

class DbSeedTest < ActiveSupport::TestCase
  self.use_transactional_tests = false # don't use fixtures for this test

  setup do
    Rails.application.load_tasks
    Rake::Task["db:environment:set"].reenable
    Rake::Task["db:schema:load"].invoke
  end

  test "db:seed runs successfully" do
    assert_nothing_raised do
      Rake::Task["db:seed"].invoke
    end

    # ensure that all talks have a year
    assert_equal Talk.where(year: nil).count, 0

    # Ensuring idempotency
    assert_no_difference "Talk.maximum(:created_at)" do
      Rake::Task["db:seed"].reenable
      Rake::Task["db:seed"].invoke
    end

    static_video_ids = Static::Video.pluck(:video_id)
    talk_video_ids = Talk.all.pluck(:video_id)

    not_created_videos_id = static_video_ids - talk_video_ids

    events = Static::Video.where(video_id: not_created_videos_id).map(&:event_name)

    events.tally.each do |event_name, missing_count|
      all_talk_count = Static::Video.where(event_name: event_name).count

      puts "#{event_name} - All: #{all_talk_count}, missing: #{missing_count}"

      if missing_count != all_talk_count
        Static::Video.where(event_name: event_name, video_id: not_created_videos_id).each do |missing_talk|
          puts "Missing talk for #{event_name}: #{missing_talk.raw_title}"
        end
        puts ""
      end
      puts "---"
    end

    assert_equal({}, events.tally)
    assert_equal 0, not_created_videos_id.count
  end
end
