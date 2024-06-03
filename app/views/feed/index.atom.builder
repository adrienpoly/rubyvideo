atom_feed do |feed|
  feed.title("Ruby Videos")
  feed.updated(@talks.first.updated_at)

  @talks.each do |talk|
    feed.entry(talk) do |entry|
      entry.title(talk.title)
      entry.summary(talk.description) if talk.description.present?
      entry.link(href: talk_url(talk.slug))
      entry.author do |author|
        author_names = talk.speakers.pluck(:name).join(", ")
        author.name(author_names.present? ? author_names : "Unknown")
      end
    end
  end
end
