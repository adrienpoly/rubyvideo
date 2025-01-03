module Speaker::Searchable
  extend ActiveSupport::Concern

  included do
    scope :ft_search, ->(query) do
      query = query&.gsub(/[^[:word:]]/, " ") || "" # remove non-word characters
      query = query.split.map { |word| "#{word}*" }.join(" ") # wildcard search
      joins("join speakers_search_index idx on speakers.id = idx.rowid")
        .where("speakers_search_index match ?", query)
    end

    scope :with_snippets, ->(**options) do
      select("speakers.*")
        .select_snippet("name", 0, **options)
        .select_snippet("github", 1, **options)
    end

    scope :ranked, -> do
      select("speakers.*,
          bm25(speakers_search_index, 2, 1) AS combined_score")
        .order(Arel.sql("combined_score ASC"))
    end

    after_create_commit :create_in_index
    after_update_commit :update_in_index
    after_destroy_commit :remove_from_index
  end

  class_methods do
    def rebuild_search_index
      connection.execute("DELETE FROM speakers_search_index")
      Speaker.find_each(&:create_in_index)
    end

    def select_snippet(column, offset, tag: "mark", omission: "…", limit: 32)
      select("snippet(speakers_search_index, #{offset}, '<#{tag}>', '</#{tag}>', '#{omission}', #{limit}) AS #{column}_snippet")
    end
  end

  def name_with_snippet
    try(:name_snippet) || name
  end

  def create_in_index
    execute_sql_with_binds "insert into speakers_search_index(rowid, name, github) values (?, ?, ?)", id, name, github
  end

  def update_in_index
    execute_sql_with_binds "update speakers_search_index set name = ?, github = ? where rowid = ?", name, github, id
  end

  def remove_from_index
    execute_sql_with_binds "delete from speakers_search_index where rowid = ?", id
  end

  private

  def execute_sql_with_binds(*statement)
    self.class.connection.execute self.class.sanitize_sql(statement)
  end
end
