class Avo::Actions::EnhanceTranscript < Avo::BaseAction
  self.name = "Enhance Transcript"
  def handle(query:, fields:, current_user:, resource:, **args)
    MeiliSearch::Rails.deactivate! do
      query.each do |record|
        record.enhance_transcript_later!
      end
    end
  end
end
