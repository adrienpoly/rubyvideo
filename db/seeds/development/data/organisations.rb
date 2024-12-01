organisations = YAML.load_file("#{Rails.root}/data/organisations.yml")
videos_to_ignore = YAML.load_file("#{Rails.root}/data/videos_to_ignore.yml")

MeiliSearch::Rails.deactivate! do
  organisations.each do |organisation|
    organisation = Organisation.find_or_create_by!(slug: organisation["slug"]) do |org|
      org.name = organisation["name"]
      org.website = organisation["website"]
      # org.twitter = organisation["twitter"]
      org.youtube_channel_name = organisation["youtube_channel_name"]
      org.kind = organisation["kind"]
      org.frequency = organisation["frequency"]
      org.youtube_channel_id = organisation["youtube_channel_id"]
      org.slug = organisation["slug"]
      # org.language = organisation["language"]
    end

    events = YAML.load_file("#{Rails.root}/data/#{organisation.slug}/playlists.yml")

    events.each do |event_data|
      event = Event.find_by(slug: event_data["slug"])
      next if event

      event = Event.create!(name: event_data["title"], date: event_data["published_at"], organisation: organisation)

      event.update!(slug: event_data["slug"])

      puts event.slug unless Rails.env.test?
      talks = YAML.load_file("#{Rails.root}/data/#{organisation.slug}/#{event.slug}/videos.yml")

      talks.each do |talk_data|
        next if talk_data["title"].blank? || videos_to_ignore.include?(talk_data["video_id"])

        talk = Talk.find_or_create_by!(title: talk_data["title"], event: event) do |tlk|
          tlk.description = talk_data["description"]
          tlk.date = talk_data["date"].presence || event_data["date"]
          tlk.video_id = talk_data["video_id"]
          tlk.video_provider = :youtube
          tlk.date = talk_data["published_at"]
          tlk.thumbnail_xs = talk_data["thumbnail_xs"] || ""
          tlk.thumbnail_sm = talk_data["thumbnail_sm"] || ""
          tlk.thumbnail_md = talk_data["thumbnail_md"] || ""
          tlk.thumbnail_lg = talk_data["thumbnail_lg"] || ""
          tlk.thumbnail_xl = talk_data["thumbnail_xl"] || ""

          slug = talk_data["title"].parameterize

          if Talk.exists?(slug: slug)
            slug += event_data["title"].parameterize
          end

          tlk.slug = slug
        end

        talk_data["speakers"]&.each do |speaker_name|
          next if speaker_name.blank?

          speaker = Speaker.find_by(slug: speaker_name.parameterize) || Speaker.find_or_create_by(name: speaker_name.strip)
          SpeakerTalk.create(speaker: speaker, talk: talk) if speaker
        end
      rescue ActiveRecord::RecordInvalid => e
        puts "#{talk_data["title"]} is duplicated #{e.message}"
      end
    end
  end
end

# reindex all talk in MeiliSearch
Talk.reindex! unless Rails.env.test?
