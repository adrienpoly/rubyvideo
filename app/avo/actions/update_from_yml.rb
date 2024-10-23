class Avo::Actions::UpdateFromYml < Avo::BaseAction
  self.name = "Update talk from yml metadata"

  def handle(query:, fields:, current_user:, resource:, **args)
    MeiliSearch::Rails.deactivate! do
      query.each do |record|
        record.update_from_yml_metadata_later!
      end
    end
    succeed "Updating talk from yml metadata"
  end
end
