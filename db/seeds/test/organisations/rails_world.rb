rails_world = organisations.create :rails_world, name: "RailsWorld", description: "Rails World", website: "https://rubyonrails.org/world", kind: 1, frequency: 1, youtube_channel_id: "UC9zbLaqReIdoFfzdUbh13Nw", youtube_channel_name: "railsofficial", slug: "railsworld", twitter: "rails"

events.create :rails_world_2023, date: "2023-10-26", organisation: rails_world, name: "RailsWorld 2023"
events.create :tropical_ruby, date: "2024-04-04", organisation: rails_world, name: "Tropical Ruby"
