class Talk::Index < ApplicationRecord
  self.table_name = :talks_search_index

  include ActiveRecord::SQLite::Index # Depends on `table_name` being assigned.
  class_attribute :index_columns, default: {title: 0, summary: 1, speaker_names: 2}

  belongs_to :talk, foreign_key: :rowid

  def self.search(query)
    query = query&.gsub(/[^[:word:]]/, " ") || "" # remove non-word characters
    query = query.split.map { |word| "#{word}*" }.join(" ") # wildcard search
    where("#{table_name} match ?", query)
  end

  def self.snippets(**)
    index_columns.each_key.reduce(all) { |relation, column| relation.snippet(column, **) }
  end

  def self.snippet(column, tag: "mark", omission: "…", limit: 32)
    offset = index_columns.fetch(column)
    select("snippet(#{table_name}, #{offset}, '<#{tag}>', '</#{tag}>', '#{omission}', #{limit}) AS #{column}_snippet")
  end

  def reindex
    update! id: talk.id, title: talk.title, summary: talk.summary, speaker_names: talk.speaker_names
  end
end
