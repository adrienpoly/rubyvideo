topics.defaults status: "approved", talks: [talks.one]

topics.create :one, name: "Topic 1"
topics.create :activerecord, name: "ActiveRecord"
topics.create :rejected, name: "Rejected", status: "rejected"

topics.create :activesupport, name: "ActiveSupport", talks: [talks.two]
