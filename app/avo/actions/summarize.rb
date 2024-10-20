class Avo::Actions::Summarize < Avo::BaseAction
  self.name = "Summarize"

  def handle(query:, fields:, current_user:, resource:, **args)
    MeiliSearch::Rails.deactivate! do
      query.each do |record|
        record.create_summary_later!
      end
    end
  end
end
