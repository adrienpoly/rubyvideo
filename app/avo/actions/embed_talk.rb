# frozen_string_literal: true

class Avo::Actions::EmbedTalk < Avo::BaseAction
  self.name = "Embed Talk"

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      record.update!(embedded: true)
    end
  end
end
