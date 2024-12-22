class Talk::Index < ApplicationRecord
  self.table_name = :talks_search_index
  self.primary_key = :rowid

  attribute :rowid, :integer
  alias_attribute :id, :rowid

  belongs_to :talk, foreign_key: :rowid

  # SQLite/Active Record doesn't pick up the virtual table primary key by default.
  # So on direct queries we need to do `Talk::Index.with_rowid.first`, if we want
  # to have `rowid`/`id` values populated in the result set.
  scope :with_rowid, -> { select("#{table_name}.rowid, #{table_name}.*") }

  def self.search(query)
    query = query&.gsub(/[^[:word:]]/, " ") || "" # remove non-word characters
    query = query.split.map { |word| "#{word}*" }.join(" ") # wildcard search
    where("#{table_name} match ?", query)
  end

  def self.snippets(**)
    COLUMNS_WITH_OFFSETS.each_key.reduce(all) { |relation, column| relation.snippet(column, **) }
  end

  def self.snippet(column, tag: "mark", omission: "…", limit: 32)
    select("snippet(#{table_name}, #{COLUMNS_WITH_OFFSETS.fetch(column)}, '<#{tag}>', '</#{tag}>', '#{omission}', #{limit}) AS #{column}_snippet")
  end

  def reindex
    update! ALL_COLUMNS.index_with { talk.public_send _1 }
  end

  private

  ALL_COLUMNS = %i[id title summary speaker_names]
  COLUMNS_WITH_OFFSETS = ALL_COLUMNS.without(:id).each.with_index.to_h
end
