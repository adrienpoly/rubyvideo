class Avo::Actions::EnhanceTranscript < Avo::BaseAction
  self.name = "Enhance Transcript"
  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |talk|
      talk.agents.improve_transcript_later
    end
  end
end
