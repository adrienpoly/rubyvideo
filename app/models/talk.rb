# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: talks
#
#  id             :integer          not null, primary key
#  date           :date
#  description    :text             default(""), not null
#  embedding      :json
#  like_count     :integer
#  slug           :string           default(""), not null
#  thumbnail_lg   :string           default(""), not null
#  thumbnail_md   :string           default(""), not null
#  thumbnail_sm   :string           default(""), not null
#  thumbnail_xl   :string           default(""), not null
#  thumbnail_xs   :string           default(""), not null
#  title          :string           default(""), not null
#  video_provider :string           default(""), not null
#  view_count     :integer
#  year           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  event_id       :integer
#  video_id       :string           default(""), not null
#
# Indexes
#
#  index_talks_on_date      (date)
#  index_talks_on_event_id  (event_id)
#  index_talks_on_slug      (slug)
#  index_talks_on_title     (title)
#
# Foreign Keys
#
#  event_id  (event_id => events.id)
#
class Talk < ApplicationRecord
  include Sluggable
  include Suggestable
  slug_from :title
  include MeiliSearch::Rails
  extend Pagy::Meilisearch

  # associations
  belongs_to :event, optional: true
  has_many :speaker_talks, dependent: :destroy, inverse_of: :talk, foreign_key: :talk_id
  has_many :speakers, through: :speaker_talks

  # validations
  validates :title, presence: true

  # delegates
  delegate :name, to: :event, prefix: true, allow_nil: true

  before_save :compute_embedding, if: :must_compute_embedding?

  # search
  meilisearch primary_key: :id, enqueue: true, raise_on_failure: Rails.env.development? do
    attribute :title
    attribute :description
    attribute :slug
    # ⚠️ This `video_id` attribute makes indexing (silently) fail with v1.3.2 of meilisearch. Error message from meilisearch (GET /tasks):
    #   "The primary key inference failed as the engine found 2 fields ending with `id` in their names: 'id' and 'video_id'. Please specify the primary key manually using the `primaryKey` query parameter"
    # Adding a custom primary_key: :id above didn't make any difference, so removing this attribute for now.
    # attribute :video_id
    attribute :video_provider
    attribute :thumbnail_sm
    attribute :thumbnail_md
    attribute :thumbnail_lg
    attribute :speakers do
      speakers.pluck(:name)
    end
    # ⚠️ This must return nil and not an empty array if no vector is available.
    # Otherwise all other indexing tasks with non-zero vector arrays will silently fail, since the engine will expect all vectors to have the same length.
    attribute :_vectors
    searchable_attributes [:title, :description]
    sortable_attributes [:title]
    filterable_attributes [:id]

    attributes_to_highlight ["*"]
  end

  # Recomputes embedding for all talks that don't have one yet.
  def self.reembed!(sleep_interval: 2.seconds, limit: nil)
    # required for querying vectors (not indexing)
    MeiliSearch::Rails.client.http_patch "/experimental-features", {vectorStore: true}

    Talk.where(embedding: nil).limit(limit).in_batches(of: 10) do |talks|
      talks.each do |talk|
        talk.compute_embedding
        talk.save!
      end
      # seems to help with not getting rate-limited by OpenAI
      sleep sleep_interval
    end

    if Talk.where(embedding: nil).exists?
      Rails.logger.warn "Some talks are still missing their embedding. You should re-run the task"
      false
    else
      Rails.logger.info "Good job, all talks have their embedding."
      true
    end
  end

  def to_meta_tags
    {
      title: title,
      description: description
    }
  end

  def thumbnail_xs
    self[:thumbnail_xs].presence || "https://i.ytimg.com/vi/#{video_id}/default.jpg"
  end

  def thumbnail_sm
    self[:thumbnail_sm].presence || "https://i.ytimg.com/vi/#{video_id}/mqdefault.jpg"
  end

  def thumbnail_md
    self[:thumbnail_md].presence || "https://i.ytimg.com/vi/#{video_id}/hqdefault.jpg"
  end

  def thumbnail_lg
    self[:thumbnail_lg].presence || "https://i.ytimg.com/vi/#{video_id}/sddefault.jpg"
  end

  def thumbnail_xl
    self[:thumbnail_xl].presence || "https://i.ytimg.com/vi/#{video_id}/maxresdefault.jpg"
  end

  def neighbors(limit: 5)
    current_talk = Talk.index.document(id)
    query_vector = current_talk.fetch("_vectors", [])
    return Talk.none if query_vector.blank?
    Talk.search("", vector: query_vector, limit: limit, filter: "id != #{id}")
  rescue MeiliSearch::ApiError => e
    Rails.logger.error("MeiliSearch error: #{e.message}")
    Talk.none
  end

  def _vectors
    embedding
  end

  def compute_embedding
    Rails.logger.info "Computing embedding for talk #{id}"
    self.embedding = Ai.embedding(title, description)
  end

  private def must_compute_embedding?
    embedding.nil? || will_save_change_to_title? || will_save_change_to_description?
  end
end
