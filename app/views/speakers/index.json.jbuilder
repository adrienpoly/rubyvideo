json.cache! ["v1", params[:per_page], @pagy.page, @speakers.maximum(:updated_at)] do
  json.speakers do
    json.array! @speakers do |speaker|
      json.partial! "speakers/speaker", speaker: speaker
    end
  end

  json.pagination do
    json.current_page @pagy.page
    json.pages @pagy.pages
    json.next_page @pagy.next
    json.prev_page @pagy.prev
    json.total_items @pagy.count
    json.items_per_page @pagy.items
  end
end
