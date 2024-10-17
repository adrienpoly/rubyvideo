# frozen_string_literal: true

class Avo::Actions::UnEmbedTalk < Avo::BaseAction
  self.name = "UnEmbed Talk"

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |record|
      record.update!(embedded: false)
    end
  end
end
