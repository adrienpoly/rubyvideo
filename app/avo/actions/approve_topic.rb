class Avo::Actions::ApproveTopic < Avo::BaseAction
  self.name = "Publish Topic"

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      record.approved!
    end
  end
end
