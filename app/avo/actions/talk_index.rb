class Avo::Actions::TalkIndex < Avo::BaseAction
  self.name = "Talk Reindex"
  self.standalone = true

  def handle(query:, fields:, current_user:, resource:, **args)
    if query.empty?
      Talk.all.in_batches.each(&:update_fts_record_later_bulk)

      succeed "All Talks reindexed"
    else
      query.in_batches.each(&:update_fts_record_later_bulk)

      succeed "Selected talks are added to the index"
    end
  end
end
