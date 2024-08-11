speakers = YAML.load_file("#{Rails.root}/data/speakers.yml")
organisations = YAML.load_file("#{Rails.root}/data/organisations.yml")
videos_to_ignore = YAML.load_file("#{Rails.root}/data/videos_to_ignore.yml")

# create speakers
speakers.each do |speaker|
  speaker = Speaker.find_or_create_by!(name: speaker["name"]) do |spk|
    spk.twitter = speaker["twitter"]
    spk.github = speaker["github"]
    spk.website = speaker["website"]
    spk.bio = speaker["bio"]
  end
end

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
          tlk.year = talk_data["year"].presence || event_data["year"]
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

Topic.find_or_create_by(name: "A/B Testing")
Topic.find_or_create_by(name: "Accessability")
Topic.find_or_create_by(name: "ActionCable")
Topic.find_or_create_by(name: "ActionMailer")
Topic.find_or_create_by(name: "ActionView")
Topic.find_or_create_by(name: "ActiveJob")
Topic.find_or_create_by(name: "ActiveRecord")
Topic.find_or_create_by(name: "ActiveStorage")
Topic.find_or_create_by(name: "ActiveSupport")
Topic.find_or_create_by(name: "AI")
Topic.find_or_create_by(name: "Algorithms")
Topic.find_or_create_by(name: "Android")
Topic.find_or_create_by(name: "Arel")
Topic.find_or_create_by(name: "Assembly")
Topic.find_or_create_by(name: "Authentication")
Topic.find_or_create_by(name: "Authorization")
Topic.find_or_create_by(name: "Automation")
Topic.find_or_create_by(name: "Awards")
Topic.find_or_create_by(name: "Background jobs")
Topic.find_or_create_by(name: "Blogging")
Topic.find_or_create_by(name: "Bootstrapping")
Topic.find_or_create_by(name: "Business Logic")
Topic.find_or_create_by(name: "Business")
Topic.find_or_create_by(name: "Caching")
Topic.find_or_create_by(name: "Camping")
Topic.find_or_create_by(name: "Career Development")
Topic.find_or_create_by(name: "CI")
Topic.find_or_create_by(name: "CI/CD")
Topic.find_or_create_by(name: "CLI")
Topic.find_or_create_by(name: "Client-side rendering")
Topic.find_or_create_by(name: "Code Golfing")
Topic.find_or_create_by(name: "Code Quality")
Topic.find_or_create_by(name: "Communication")
Topic.find_or_create_by(name: "Community")
Topic.find_or_create_by(name: "Compiling")
Topic.find_or_create_by(name: "Components")
Topic.find_or_create_by(name: "Computer Vision")
Topic.find_or_create_by(name: "Concurrency")
Topic.find_or_create_by(name: "Containers")
Topic.find_or_create_by(name: "CRuby")
Topic.find_or_create_by(name: "Crystal")
Topic.find_or_create_by(name: "CSS ")
Topic.find_or_create_by(name: "Data Integrity")
Topic.find_or_create_by(name: "Data Processing")
Topic.find_or_create_by(name: "Database Sharding")
Topic.find_or_create_by(name: "Databases")
Topic.find_or_create_by(name: "Debugging")
Topic.find_or_create_by(name: "Deployment")
Topic.find_or_create_by(name: "Design Patterns")
Topic.find_or_create_by(name: "Developer Tooling")
Topic.find_or_create_by(name: "Developer Tooling")
Topic.find_or_create_by(name: "DevOps")
Topic.find_or_create_by(name: "Distributed Systems")
Topic.find_or_create_by(name: "Diversity & Inclusion")
Topic.find_or_create_by(name: "Docker")
Topic.find_or_create_by(name: "Documentation")
Topic.find_or_create_by(name: "Domain Driven Design")
Topic.find_or_create_by(name: "dry-rb")
Topic.find_or_create_by(name: "DSL")
Topic.find_or_create_by(name: "Duck Typing")
Topic.find_or_create_by(name: "Duck Typing")
Topic.find_or_create_by(name: "DX")
Topic.find_or_create_by(name: "Editor")
Topic.find_or_create_by(name: "Elm")
Topic.find_or_create_by(name: "Encoding")
Topic.find_or_create_by(name: "Encryption")
Topic.find_or_create_by(name: "Engineering Culture")
Topic.find_or_create_by(name: "Error Handling")
Topic.find_or_create_by(name: "Ethics")
Topic.find_or_create_by(name: "Event Sourcing")
Topic.find_or_create_by(name: "Fibers")
Topic.find_or_create_by(name: "Flaky Tests")
Topic.find_or_create_by(name: "Frontend")
Topic.find_or_create_by(name: "Functional Programming")
Topic.find_or_create_by(name: "Game Shows")
Topic.find_or_create_by(name: "Games")
Topic.find_or_create_by(name: "Geocoding")
Topic.find_or_create_by(name: "git")
Topic.find_or_create_by(name: "Go")
Topic.find_or_create_by(name: "GraphQL")
Topic.find_or_create_by(name: "gRPC")
Topic.find_or_create_by(name: "Hacking")
Topic.find_or_create_by(name: "Hanami")
Topic.find_or_create_by(name: "Hotwire")
Topic.find_or_create_by(name: "HTML")
Topic.find_or_create_by(name: "HTTP API")
Topic.find_or_create_by(name: "Hybrid Apps")
Topic.find_or_create_by(name: "IDE")
Topic.find_or_create_by(name: "Indie Developer")
Topic.find_or_create_by(name: "Inspiration")
Topic.find_or_create_by(name: "Internals")
Topic.find_or_create_by(name: "Interview")
Topic.find_or_create_by(name: "iOS")
Topic.find_or_create_by(name: "JavaScript")
Topic.find_or_create_by(name: "JIT")
Topic.find_or_create_by(name: "Job Interviewing")
Topic.find_or_create_by(name: "JRuby")
Topic.find_or_create_by(name: "Junior devs")
Topic.find_or_create_by(name: "JVM")
Topic.find_or_create_by(name: "JWT")
Topic.find_or_create_by(name: "Kafka")
Topic.find_or_create_by(name: "Keynotes")
Topic.find_or_create_by(name: "Leadership")
Topic.find_or_create_by(name: "Legacy Applications")
Topic.find_or_create_by(name: "Licensing")
Topic.find_or_create_by(name: "Lightning Talks")
Topic.find_or_create_by(name: "Linters")
Topic.find_or_create_by(name: "Live Coding")
Topic.find_or_create_by(name: "LLM")
Topic.find_or_create_by(name: "Localization")
Topic.find_or_create_by(name: "Logging")
Topic.find_or_create_by(name: "LSP")
Topic.find_or_create_by(name: "Machine Learning")
Topic.find_or_create_by(name: "Memory Managment")
Topic.find_or_create_by(name: "Mental Health")
Topic.find_or_create_by(name: "Mentorship")
Topic.find_or_create_by(name: "MFA/2FA")
Topic.find_or_create_by(name: "Microcontroller")
Topic.find_or_create_by(name: "Microservices")
Topic.find_or_create_by(name: "MJIT")
Topic.find_or_create_by(name: "Mocking")
Topic.find_or_create_by(name: "Monolith")
Topic.find_or_create_by(name: "mruby")
Topic.find_or_create_by(name: "Multitenancy")
Topic.find_or_create_by(name: "Music")
Topic.find_or_create_by(name: "MVP")
Topic.find_or_create_by(name: "MySQL")
Topic.find_or_create_by(name: "Naming")
Topic.find_or_create_by(name: "Native Apps")
Topic.find_or_create_by(name: "Native Extensions")
Topic.find_or_create_by(name: "Observability")
Topic.find_or_create_by(name: "Offline")
Topic.find_or_create_by(name: "OOP")
Topic.find_or_create_by(name: "Open Source")
Topic.find_or_create_by(name: "Organizational Skills")
Topic.find_or_create_by(name: "ORM")
Topic.find_or_create_by(name: "Pair Programming")
Topic.find_or_create_by(name: "Panel")
Topic.find_or_create_by(name: "Parallelism")
Topic.find_or_create_by(name: "Parsing")
Topic.find_or_create_by(name: "Passwords")
Topic.find_or_create_by(name: "People Skills")
Topic.find_or_create_by(name: "Performance")
Topic.find_or_create_by(name: "Personal Development")
Topic.find_or_create_by(name: "Phlex")
Topic.find_or_create_by(name: "Podcasts")
Topic.find_or_create_by(name: "PostgreSQL")
Topic.find_or_create_by(name: "Pricing")
Topic.find_or_create_by(name: "Privacy")
Topic.find_or_create_by(name: "Productivity")
Topic.find_or_create_by(name: "Profiling")
Topic.find_or_create_by(name: "Project Planning")
Topic.find_or_create_by(name: "PWA")
Topic.find_or_create_by(name: "Q&A")
Topic.find_or_create_by(name: "Rack")
Topic.find_or_create_by(name: "Ractors")
Topic.find_or_create_by(name: "Rails at Scale")
Topic.find_or_create_by(name: "Rails Engine")
Topic.find_or_create_by(name: "Rails Upgrades")
Topic.find_or_create_by(name: "React")
Topic.find_or_create_by(name: "Real-time applications")
Topic.find_or_create_by(name: "Refactoring")
Topic.find_or_create_by(name: "Regex")
Topic.find_or_create_by(name: "Remote Work")
Topic.find_or_create_by(name: "REST API")
Topic.find_or_create_by(name: "REST")
Topic.find_or_create_by(name: "RJIT")
Topic.find_or_create_by(name: "Robot")
Topic.find_or_create_by(name: "Ruby Implementations")
Topic.find_or_create_by(name: "Ruby on Rails")
Topic.find_or_create_by(name: "Ruby VM")
Topic.find_or_create_by(name: "Rubygems")
Topic.find_or_create_by(name: "Rust")
Topic.find_or_create_by(name: "Scaling")
Topic.find_or_create_by(name: "Security")
Topic.find_or_create_by(name: "Server-side rendering")
Topic.find_or_create_by(name: "Servers")
Topic.find_or_create_by(name: "Service Objects")
Topic.find_or_create_by(name: "Shoes.rb")
Topic.find_or_create_by(name: "Sidekiq")
Topic.find_or_create_by(name: "Sinatra")
Topic.find_or_create_by(name: "Software Architecture")
Topic.find_or_create_by(name: "Sonic Pi")
Topic.find_or_create_by(name: "Sorbet")
Topic.find_or_create_by(name: "SPA")
Topic.find_or_create_by(name: "SQL")
Topic.find_or_create_by(name: "SQLite")
Topic.find_or_create_by(name: "Startups")
Topic.find_or_create_by(name: "Static Typing")
Topic.find_or_create_by(name: "Stimulus")
Topic.find_or_create_by(name: "Success Stories")
Topic.find_or_create_by(name: "Swift")
Topic.find_or_create_by(name: "Syntax")
Topic.find_or_create_by(name: "System Programming")
Topic.find_or_create_by(name: "Tailwind CSS")
Topic.find_or_create_by(name: "TDD")
Topic.find_or_create_by(name: "Teaching")
Topic.find_or_create_by(name: "Team Building")
Topic.find_or_create_by(name: "Teams")
Topic.find_or_create_by(name: "Teamwork")
Topic.find_or_create_by(name: "Test Coverage")
Topic.find_or_create_by(name: "Test Framework")
Topic.find_or_create_by(name: "Testing")
Topic.find_or_create_by(name: "Threads")
Topic.find_or_create_by(name: "Timezones")
Topic.find_or_create_by(name: "Tips & Tricks")
Topic.find_or_create_by(name: "Trailblazer")
Topic.find_or_create_by(name: "Translation")
Topic.find_or_create_by(name: "Transpilation")
Topic.find_or_create_by(name: "TruffleRuby")
Topic.find_or_create_by(name: "Turbo Native")
Topic.find_or_create_by(name: "Turbo")
Topic.find_or_create_by(name: "Type Checking")
Topic.find_or_create_by(name: "Types")
Topic.find_or_create_by(name: "Typing")
Topic.find_or_create_by(name: "UI Design")
Topic.find_or_create_by(name: "UI")
Topic.find_or_create_by(name: "Usability")
Topic.find_or_create_by(name: "Version Control")
Topic.find_or_create_by(name: "ViewComponent")
Topic.find_or_create_by(name: "Views")
Topic.find_or_create_by(name: "Virtual Machine")
Topic.find_or_create_by(name: "Vue.js")
Topic.find_or_create_by(name: "Web Server")
Topic.find_or_create_by(name: "Websockets")
Topic.find_or_create_by(name: "why the lucky stiff")
Topic.find_or_create_by(name: "Workshop")
Topic.find_or_create_by(name: "Writing")
Topic.find_or_create_by(name: "YARV")
Topic.find_or_create_by(name: "YJIT")
