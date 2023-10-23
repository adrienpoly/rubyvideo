xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Ruby Videos"
    xml.description "A collection of talks of Ruby conferences around the world"
    xml.link root_url

    @talks.each do |talk|
      xml.item do
        xml.title talk.title
        xml.description talk.description
        xml.pubDate DateTime.parse(talk.date.to_s).rfc822
        xml.link talk_url(talk.slug)
        xml.guid talk_url(talk.slug)
      end
    end
  end
end
