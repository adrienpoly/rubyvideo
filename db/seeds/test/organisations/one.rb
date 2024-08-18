one = organisations.create :one, name: "RailsConf", description: "Rails conf from Ruby central", website: "https://railsconf.org/", kind: 1, frequency: 1, youtube_channel_id: "UCWnPjmqvljcafA0z2U1fwKQ", youtube_channel_name: "confreaks", slug: "railsconf"

events.create :one, date: "2017-05-01", organisation: one, city: "Phoenix", name: "RailsConf 2017", slug: "rails-conf-2017"
