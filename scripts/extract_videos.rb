# start this script with the rails runner command
# $ rails runner scripts/extract_videos.rb
# Once you have created the playlists it will retrieve the videos
#

organisations = YAML.load_file("#{Rails.root}/data_preparation/organisations.yml")

# for each playlist create a directory and add a videos.yml file
def create_playlist_items(playlist, organisation_slug)
  puts "extracting videos for playlist : #{playlist.title}"
  playlist_videos = Youtube::PlaylistItems.new.all(playlist_id: playlist.id)
  playlist_videos.sort_by! { |video| video.published_at }

  FileUtils.mkdir_p(File.join(Rails.root, "data_preparation", organisation_slug, playlist.slug))

  # by default we use Youtube::VideoMetadata but in playlists.yml you can specify a different parser
  parser = playlist.metadata_parser&.constantize || Youtube::NullParser
  playlist_videos.map! { |metadata| parser.new(metadata: metadata, event_name: playlist.title).cleaned }

  path = "#{File.join(Rails.root, "data_preparation", organisation_slug, playlist.slug)}/videos.yml"
  puts "#{playlist_videos.length} videos have ben added to  : #{playlist.title}"
  File.write(path, playlist_videos.map { |item| item.to_h.stringify_keys }.to_yaml)
end

# this is the main loop
organisations.each do |organisation|
  puts "extracting videos for #{organisation["slug"]}"
  playlists = YAML.load_file("#{Rails.root}/data_preparation/#{organisation["slug"]}/playlists.yml").map { |item| OpenStruct.new(item) }

  playlists.each do |playlist|
    create_playlist_items(playlist, organisation["slug"])
  end
end
