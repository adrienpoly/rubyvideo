class Talk::Downloader < ActiveRecord::AssociatedObject
  def download_path
    Rails.root / "tmp" / "videos" / talk.video_provider / "#{talk.video_id}.mp4"
  end

  def downloaded?
    download_path.exist?
  end

  def downloadable?
    talk.youtube?
  end

  def download!
    if !downloadable?
      puts "Talk #{talk.video_id} is not a YouTube video"

      return
    end

    (puts "#{talk.video_id} exists, skipping..." && return) if downloaded?

    puts "#{talk.video_id} downloading..."

    Command.run(%(yt-dlp --output "#{download_path}" --format "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]" "https://www.youtube.com/watch?v=#{talk.video_id}"))
  end
end
