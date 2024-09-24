class Avo::Actions::AssignCanonicalTopic < Avo::BaseAction
  self.name = "Assign Canonical Topic"
  # self.visible = -> do
  #   true
  # end

  def fields
    field :topic_id, as: :select, name: "Canonical topic",
      help: "The name of the topic to be set as canonical",
      options: -> { Topic.approved.order(:name).pluck(:name, :id) }
  end

  def handle(query:, fields:, current_user:, resource:, **args)
    canonical_topic = Topic.find(fields[:topic_id])

    query.each do |record|
      record.assign_canonical_topic!(canonical_topic: canonical_topic)
    end

    succeed "Assigning canonical topic #{canonical_topic.name} to #{query.count} topics"
    redirect_to avo.resources_topic_path(canonical_topic)
  end
end
