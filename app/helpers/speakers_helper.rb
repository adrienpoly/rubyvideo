module SpeakersHelper
  def form_title_for_user_kind(user_kind)
    case user_kind
    when :owner, :admin
      "Editing speaker"
    when :signed_in, :anonymous
      "Suggesting a modification"
    end
  end
end
