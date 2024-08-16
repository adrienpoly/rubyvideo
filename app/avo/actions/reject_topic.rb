class Avo::Actions::RejectTopic < Avo::BaseAction
  self.name = "Reject Topic"
  # self.visible = -> do
  #   true
  # end

  # def fields
  #   # Add Action fields here
  # end

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      record.rejected!
    end
  end
end
