class Avo::Actions::ExtractTopics < Avo::BaseAction
  self.name = "Extract Topics"

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |talk|
      # AnalyzeTalkTopicsJob.perform_later(talk)
      AnalyzeTalkTopicsJob.new.perform(talk)
    end
  end
end
