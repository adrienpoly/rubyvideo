class SitemapsController < ApplicationController
  def show
    render xml: generate_sitemap_string
  end

  private

  def generate_sitemap_string
    Rails.cache.fetch("sitemap", expires_in: 24.hours) do
      adapter = SitemapStringAdapter.new

      SitemapGenerator::Sitemap.default_host = "https://www.rubyvideo.dev"

      SitemapGenerator::Sitemap.create(adapter: adapter) do
        add talks_path, priority: 0.9, changefreq: "daily"

        Talk.find_each do |talk|
          add talk_path(talk), priority: 0.8, lastmod: talk.updated_at
        end

        add speakers_path, priority: 0.7, changefreq: "daily"

        Speaker.find_each do |speaker|
          add speaker_path(speaker), priority: 0.8, lastmod: speaker.updated_at
        end
      end

      adapter.sitemap_content
    end
  end

  class SitemapStringAdapter
    attr_reader :sitemap_content

    def write(location, raw_data)
      @sitemap_content ||= ""
      @sitemap_content << raw_data
    end
  end
end
