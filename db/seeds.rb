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

topics = ["A/B Testing",
  "Accessability",
  "ActionCable",
  "ActionMailer",
  "ActionView",
  "ActiveJob",
  "ActiveRecord",
  "ActiveStorage",
  "ActiveSupport",
  "AI",
  "Algorithms",
  "Android",
  "Arel",
  "Assembly",
  "Authentication",
  "Authorization",
  "Automation",
  "Awards",
  "Background jobs",
  "Blogging",
  "Bootstrapping",
  "Business Logic",
  "Business",
  "Caching",
  "Camping",
  "Career Development",
  "CI",
  "CI/CD",
  "CLI",
  "Client-side rendering",
  "Code Golfing",
  "Code Quality",
  "Communication",
  "Community",
  "Compiling",
  "Components",
  "Computer Vision",
  "Concurrency",
  "Containers",
  "CRuby",
  "Crystal",
  "CSS",
  "Data Integrity",
  "Data Processing",
  "Database Sharding",
  "Databases",
  "Debugging",
  "Deployment",
  "Design Patterns",
  "Developer Tooling",
  "DevOps",
  "Distributed Systems",
  "Diversity & Inclusion",
  "Docker",
  "Documentation",
  "Domain Driven Design",
  "dry-rb",
  "DSL",
  "Duck Typing",
  "DX",
  "Editor",
  "Elm",
  "Encoding",
  "Encryption",
  "Engineering Culture",
  "Error Handling",
  "Ethics",
  "Event Sourcing",
  "Fibers",
  "Flaky Tests",
  "Frontend",
  "Functional Programming",
  "Game Shows",
  "Games",
  "Geocoding",
  "git",
  "Go",
  "GraphQL",
  "gRPC",
  "Hacking",
  "Hanami",
  "Hotwire",
  "HTML",
  "HTTP API",
  "Hybrid Apps",
  "IDE",
  "Indie Developer",
  "Inspiration",
  "Internals",
  "Interview",
  "iOS",
  "JavaScript",
  "JIT",
  "Job Interviewing",
  "JRuby",
  "Junior devs",
  "JVM",
  "JWT",
  "Kafka",
  "Keynote",
  "Leadership",
  "Legacy Applications",
  "Licensing",
  "Lightning Talks",
  "Linters",
  "Live Coding",
  "LLM",
  "Localization",
  "Logging",
  "LSP",
  "Machine Learning",
  "Memory Managment",
  "Mental Health",
  "Mentorship",
  "MFA/2FA",
  "Microcontroller",
  "Microservices",
  "MJIT",
  "Mocking",
  "Monolith",
  "mruby",
  "Multitenancy",
  "Music",
  "MVP",
  "MySQL",
  "Naming",
  "Native Apps",
  "Native Extensions",
  "Observability",
  "Offline",
  "OOP",
  "Open Source",
  "Organizational Skills",
  "ORM",
  "Pair Programming",
  "Panel",
  "Parallelism",
  "Parsing",
  "Passwords",
  "People Skills",
  "Performance",
  "Personal Development",
  "Phlex",
  "Podcasts",
  "PostgreSQL",
  "Pricing",
  "Privacy",
  "Productivity",
  "Profiling",
  "Project Planning",
  "PWA",
  "Q&A",
  "Rack",
  "Ractors",
  "Rails at Scale",
  "Rails Engine",
  "Rails Upgrades",
  "React",
  "Real-time applications",
  "Refactoring",
  "Regex",
  "Remote Work",
  "REST API",
  "REST",
  "RJIT",
  "Robot",
  "Ruby Implementations",
  "Ruby on Rails",
  "Ruby VM",
  "Rubygems",
  "Rust",
  "Scaling",
  "Security",
  "Server-side rendering",
  "Servers",
  "Service Objects",
  "Shoes.rb",
  "Sidekiq",
  "Sinatra",
  "Software Architecture",
  "Sonic Pi",
  "Sorbet",
  "SPA",
  "SQL",
  "SQLite",
  "Startups",
  "Static Typing",
  "Stimulus",
  "Success Stories",
  "Swift",
  "Syntax",
  "System Programming",
  "Tailwind CSS",
  "TDD",
  "Teaching",
  "Team Building",
  "Teams",
  "Teamwork",
  "Test Coverage",
  "Test Framework",
  "Testing",
  "Threads",
  "Timezones",
  "Tips & Tricks",
  "Trailblazer",
  "Translation",
  "Transpilation",
  "TruffleRuby",
  "Turbo Native",
  "Turbo",
  "Type Checking",
  "Types",
  "Typing",
  "UI Design",
  "UI",
  "Usability",
  "Version Control",
  "ViewComponent",
  "Views",
  "Virtual Machine",
  "Vue.js",
  "Web Server",
  "Websockets",
  "why the lucky stiff",
  "Workshop",
  "Writing",
  "YARV",
  "YJIT"]

# create topics
topics.each do |topic|
  Topic.find_or_create_by(name: topic)
end
