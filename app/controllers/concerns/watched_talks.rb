module WatchedTalks
  extend ActiveSupport::Concern

  included do
    helper_method :user_watched_talks_ids
  end

  private

  def user_watched_talks_ids
    @user_watched_talks_ids ||= Current.user&.watched_talks&.pluck(:talk_id) || []
  end
end
