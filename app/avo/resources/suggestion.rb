class Avo::Resources::Suggestion < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :idlo
    field :content, as: :text, only_on: :index do
      record.content.map { |key, value| "#{key}: #{value}" }.to_sentence.truncate(50)
    end
    field :content, as: :key_value, hide_on: :index
    field :status, as: :status, loading_when: [:pending], success_when: [:approved], link_to_record: true, hide_on: [:forms]
    field :suggestable, as: :belongs_to, polymorphic_as: :suggestable
    field :approved_by, as: :belongs_to
    field :suggested_by, as: :belongs_to
  end
end
