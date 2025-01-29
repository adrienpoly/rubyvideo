json.talks @talks do |talk|
  json.slug talk.slug
  json.title talk.title
  json.date talk.date
  json.url talk_url(talk)
  json.video_id talk.video_id
  json.video_provider talk.video_provider

  json.event do
    json.slug talk.event&.slug
    json.name talk.event&.name
  end

  json.speakers talk.speakers do |speaker|
    json.slug speaker.slug
    json.name speaker.name
  end
end

json.pagination do
  json.current_page @pagy.page
  json.total_pages @pagy.pages
  json.total_count @pagy.count
  json.next_page @pagy.next
  json.prev_page @pagy.prev
end
