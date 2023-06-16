module TalksHelper
  def view_transition_style(talk_id:, from_talk_id:, name:)
    return unless from_talk_id && talk_id == from_talk_id.to_i

    "view-transition-name: #{name}"
  end
end
