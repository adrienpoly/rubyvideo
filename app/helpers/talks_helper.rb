module TalksHelper
  def link_to_talk(talk = nil, options = {}, html_options = {}, &block)
    raise ArgumentError, "must pass an instance of talk to this helper method" unless talk.present? && talk.is_a?(Talk)

    url, target = if talk.date > 2.weeks.ago
      ["https://youtube.com/watch?v=#{talk.video_id}", "_blank"]
    else
      [talk_path(talk, options), nil]
    end

    html_options[:target] = target if target

    link_to(url, html_options) do
      if block
        yield
      else
        talk.to_s
      end
    end
  end
end
