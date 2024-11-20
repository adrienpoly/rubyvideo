# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

def run(command)
  puts command
  output = `#{command}`

  puts output

  output
end

desc "Export Conference assets"
task :export_assets, [:conference_name] => :environment do |t, args|
  sketchtool = "/Applications/Sketch.app/Contents/Resources/sketchtool/bin/sketchtool"
  sketch_file = "./RubyVideo.sketch"

  response = JSON.parse(run("#{sketchtool} list artboards #{sketch_file}"))
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

        run "#{sketchtool} export artboards #{sketch_file} --items=#{item_ids} --output=#{target_directory} --save-for-web=YES --formats=webp"
      end
    end

    threads.each(&:join)
  end
end
