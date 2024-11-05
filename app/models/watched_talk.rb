class WatchedTalk < ApplicationRecord
  belongs_to :user, default: -> { Current.user }
  belongs_to :talk
end
