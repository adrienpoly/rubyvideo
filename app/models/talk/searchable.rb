module Talk::Searchable
  extend ActiveSupport::Concern

  included do
    scope :ft_search, ->(query) do
      query = query&.gsub(/[^[:word:]]/, " ") || "" # remove non-word characters
      query = query.split.map { |word| "#{word}*" }.join(" ") # wildcard search
      joins("join talks_search_index idx on talks.id = idx.rowid")
        .where("talks_search_index match ?", query)
    end

    scope :with_snippets, ->(**options) do
      select("talks.*")
        .select_snippet("title", 0, **options)
        .select_snippet("summary", 1, **options)
        .select_snippet("speaker_names", 2, **options)
    end

    scope :ranked, -> do
      order(Arel.sql("bm25(talks_search_index, 10.0, 1.0, 5.0) ASC, talks.date DESC"))
    end

    after_create_commit :create_in_index
    after_update_commit :update_in_index
    after_destroy_commit :remove_from_index
  end

  class_methods do
    def rebuild_search_index
      connection.execute("DELETE FROM talks_search_index")
      Talk.find_each(&:create_in_index)
    end

    def select_snippet(column, offset, tag: "mark", omission: "…", limit: 32)
      select("snippet(talks_search_index, #{offset}, '<#{tag}>', '</#{tag}>', '#{omission}', #{limit}) AS #{column}_snippet")
    end
  end

  def title_with_snippet
    try(:title_snippet) || title
  end

  def create_in_index
    execute_sql_with_binds "insert into talks_search_index(rowid, title, summary, speaker_names) values (?, ?, ?, ?)", id, title, summary, speaker_names
  end

  def update_in_index
    execute_sql_with_binds "update talks_search_index set title = ?, summary = ?, speaker_names = ? where rowid = ?", title, summary, speaker_names, id
  end

  def remove_from_index
    execute_sql_with_binds "delete from talks_search_index where rowid = ?", id
  end

  private

  def execute_sql_with_binds(*statement)
    self.class.connection.execute self.class.sanitize_sql(statement)
  end
end
