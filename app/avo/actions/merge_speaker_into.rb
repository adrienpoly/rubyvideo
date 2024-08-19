class Avo::Actions::MergeSpeakerInto < Avo::BaseAction
  self.name = "Merge Speaker Into"
  self.visible = -> do
    view == :show
  end
  self.message = "Are you sure you want to merge this speaker into the selected reciepient speaker. It will transfer all talks to the recipient speaker and delete this speaker"
  self.confirm_button_label = "Merge and destroy speaker"
  self.cancel_button_label = "Not yet"

  def fields
    field :speaker_id, as: :select, name: "Recipient speaker",
      help: "The ID of the speaker to merge into",
      options: -> { Speaker.order(:name).pluck(:name, :id) }
  end

  def handle(query:, fields:, current_user:, resource:, **args)
    recipient_speaker = Speaker.find(fields[:speaker_id])
    speaker_to_merge = query.first

    speaker_to_merge.talks.each do |talk|
      SpeakerTalk.find_or_create_by!(speaker: recipient_speaker, talk: talk)
    end

    speaker_to_merge.talks.destroy_all
    speaker_to_merge.destroy
    redirect_to avo.resources_speaker_path(recipient_speaker), allow_other_host: true, status: 303
  end
end
