class Avo::Actions::AssignCanonicalEvent < Avo::BaseAction
  self.name = "Assign Canonical Event"
  # self.visible = -> do
  #   true
  # end

  def fields
    field :event_id, as: :select, name: "Canonical event",
      help: "The name of the event to be set as canonical",
      options: -> { Event.order(:name).pluck(:name, :id) }
  end

  def handle(query:, fields:, current_user:, resource:, **args)
    canonical_event = Event.find(fields[:event_id])

    query.each do |record|
      record.assign_canonical_event!(canonical_event: canonical_event)
    end

    succeed "Assigning canonical event #{canonical_event.name} to #{query.count} events"
    redirect_to avo.resources_event_path(canonical_event)
  end
end
