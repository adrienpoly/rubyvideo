class TalkFts < ApplicationRecord
  self.primary_key = "rowid"
  belongs_to :talk, foreign_key: "rowid"

  def self.update_or_create(talk)
    if exists?(rowid: talk.id)
      update_fts(talk)
    else
      create_fts(talk)
    end
  end

  private

  def self.update_fts(talk)
    update_sql = ActiveRecord::Base.sanitize_sql_array([
      "UPDATE talk_fts SET title = ?, speaker_names = ?, summary = ? WHERE rowid = ?",
      talk.title, talk.speakers.pluck(:name).join(" "), talk.summary, talk.id
    ])
    ActiveRecord::Base.connection.execute(update_sql)
  end

  def self.create_fts(talk)
    insert_sql = ActiveRecord::Base.sanitize_sql_array([
      "INSERT INTO talk_fts (rowid, title, speaker_names, summary) VALUES (?, ?, ?, ?)",
      talk.id, talk.title, talk.speakers.pluck(:name).join(" "), talk.summary
    ])
    ActiveRecord::Base.connection.execute(insert_sql)
  end
end
