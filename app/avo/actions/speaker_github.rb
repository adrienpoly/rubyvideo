class Avo::Actions::SpeakerGitHub < Avo::BaseAction
  self.name = "Try to enhance Speaker profile with GitHub"

  def handle(query:, fields:, current_user:, resource:, **args)
    query.each do |speaker|
      speaker.profile_enhancer.enhance_all_later
    end
  end
end
