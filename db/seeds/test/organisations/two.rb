two = organisations.create :two, name: "RubyConfTh", description: "Ruby Rails Thailand", website: "https://rubyconfth.com/", kind: 1, frequency: 1, youtube_channel_id: "UCWnPjmqvljcsqsdafA0z2U1fwKQ", youtube_channel_name: "rubyconfth", slug: "railsconfth"

events.create :two, date: "2023-05-01", organisation: two, city: "Bangkok", name: "RubyConf TH 2022", slug: "ruby-conf-th-2022"
