module TalksHelper
  def normalize_back_to(back_to)
    return nil if back_to.blank?

    uri = URI.parse(back_to)
    params = Rack::Utils.parse_query(uri.query.to_s).except("infinite_count", "format", "page")
    uri.query = params.present? ? params.to_query : nil
    uri.to_s
  end
end
