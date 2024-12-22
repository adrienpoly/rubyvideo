module Talk::Searchable
  extend ActiveSupport::Concern

  DATE_WEIGHT = 0.000000001

  included do
    has_one :index, -> { with_rowid }, foreign_key: :rowid, dependent: :destroy

    scope :ft_search, ->(query) { joins(:index).merge(Talk::Index.search(query)) }

    scope :with_snippets, ->(**options) do
      select("talks.*").merge(Talk::Index.snippets(**options))
    end

    scope :ranked, -> do
      select("talks.*,
          bm25(talks_search_index, 10.0, 1.0, 5.0) +
          (strftime('%s', 'now') - strftime('%s', talks.date)) * #{DATE_WEIGHT} AS combined_score")
        .order(combined_score: :asc)
    end

    after_create_commit :create_in_index
    after_update_commit :update_in_index
  end

  class_methods do
    def reindex_all
      Index.delete_all
      Talk.find_each(&:create_in_index)
    end
  end

  def title_with_snippet
    try(:title_snippet) || title
  end

  def create_in_index
    build_index.reindex
  end

  def update_in_index
    index.reindex
  end
end
