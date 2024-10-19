class Avo::Actions::TalkIndex < Avo::BaseAction
  self.name = "Talk Reindex"
  self.standalone = true

  def handle(query:, fields:, current_user:, resource:, **args)
    if query.empty?
      Talk.reindex!
      succeed "All Talks reindexed"
    else
      query.each do |record|
        record.index!
      end
      succeed "Selected talks are added to the index"
    end
  end
end
