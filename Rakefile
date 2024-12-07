# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

desc "Verify all talks with start_cue have thumbnails"
task verify_thumbnails: :environment do |t, args|
  thumbnails_count = 0
  child_talks_with_missing_thumbnails = []

  Talk.where(meta_talk: true).flat_map(&:child_talks).each do |child_talk|
    if child_talk.static_metadata
      if child_talk.static_metadata.start_cue.present? && child_talk.static_metadata.start_cue != "TODO"
        if child_talk.thumbnail_extractor.thumbnail_path.exist?
          thumbnails_count += 1
        else
          puts "missing thumbnail for child_talk: #{child_talk.video_id} at: #{child_talk.thumbnail_extractor.thumbnail_path}"
          child_talks_with_missing_thumbnails << child_talk
        end
      end
    else
      puts "missing static_metadata for child_talk: #{child_talk.video_id}"
      child_talks_with_missing_thumbnails << child_talk
    end
  end

  if child_talks_with_missing_thumbnails.any?
    raise "missing #{child_talks_with_missing_thumbnails.count} thumbnails"
  else
    puts "All #{thumbnails_count} thumbnails present!"
  end
end

desc "Download mp4 files for all meta talks"
task download_meta_talks: :environment do |t, args|
  Talk.where(meta_talk: true).each do |meta_talk|
    meta_talk.downloader.download!
  end
end

desc "Download mp4 files for all meta talks with missing thumbnails"
task download_missing_meta_talks: :environment do |t, args|
  meta_talks = Talk.where(meta_talk: true)
  extractable_meta_talks = meta_talks.select { |talk| talk.thumbnail_extractor.extractable? }
  missing_talks = extractable_meta_talks.reject { |talk| talk.thumbnail_extractor.extracted? }
  missing_talks_without_downloads = missing_talks.reject { |talk| talk.downloader.downloaded? }

  puts "Found #{missing_talks_without_downloads.size} missing talks without downloaded videos."

  missing_talks_without_downloads.each do |talk|
    talk.downloader.download!
  end
end

desc "Fetch thumbnails for meta talks for all cues"
task extract_thumbnails: :environment do |t, args|
  Talk.where(meta_talk: true).each do |meta_video|
    meta_video.thumbnail_extractor.extract!
  end
end

desc "Export Conference assets"
task :export_assets, [:conference_name] => :environment do |t, args|
  sketchtool = "/Applications/Sketch.app/Contents/Resources/sketchtool/bin/sketchtool"
  sketch_file = "./RubyVideo.sketch"

  response = JSON.parse(Command.run("#{sketchtool} list artboards #{sketch_file}"))
  pages = response["pages"]

  conference_pages = pages.select { |page| page["artboards"].any? && Static::Playlist.where(title: page["name"]).any? }

  if (conference_name = args[:conference_name])
    conference_pages = conference_pages.select { |page|
      playlist = Static::Playlist.find_by(title: page["name"])

      if playlist
        page["name"] == conference_name || playlist.slug == conference_name
      else
        page["name"] == conference_name
      end
    }
  end

  conference_pages.each_slice(8) do |pages|
    threads = []

    pages.each do |page|
      threads << Thread.new do
        artboard_exports = page["artboards"].select { |artboard| artboard["name"].in?(["card", "featured", "avatar", "banner", "poster"]) }
        event = Event.find_by(name: page["name"])

        next if event.nil?

        item_ids = artboard_exports.map { |artboard| artboard["id"] }.join(",")
        target_directory = Rails.root.join("app", "assets", "images", "events", event.organisation.slug, event.slug)

        Command.run "#{sketchtool} export artboards #{sketch_file} --items=#{item_ids} --output=#{target_directory} --save-for-web=YES --formats=webp"
      end
    end

    threads.each(&:join)
  end
end
