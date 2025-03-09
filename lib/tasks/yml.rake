require_relative "../yml_formatter"

TALKS_SLUGS_FILE = "data/talks_slugs.yml"
API_ENDPOINT = "https://www.rubyvideo.dev/talks.json"
# API_ENDPOINT = "http://localhost:3000/talks.json"

namespace :yml do
  desc "normalize the yml file"
  task normalize: :environment do
    Dir.glob("data/**/*/videos.yml").each do |videos_yml_path|
      # first we normalize the comments
      yaml_content = File.read(videos_yml_path)
      reformatted_content = YmlFormatter.normalize_comment_lines(yaml_content)

      # then we normalize the content
      reformatted_content = YmlFormatter.normalize_commented_yaml_file(reformatted_content)
      File.write(videos_yml_path, reformatted_content)
    end

    # then we ensure the style is correct with prettier
    system("yarn format:yml")
  end

  desc "dump talks slugs to a local yml file"
  task dump_talks_slugs: :environment do
    data = YAML.load_file(TALKS_SLUGS_FILE)
    dump_updated_at = data&.dig("updated_at")

    talks_slugs = data&.dig("talks_slugs") || {}
    current_page = 1

    loop do
      uri = URI("#{API_ENDPOINT}?page=#{current_page}&limit=500&sort=created_at_asc&created_after=#{dump_updated_at}")
      response = Net::HTTP.get(uri)
      parsed_response = JSON.parse(response)

      parsed_response["talks"].each do |talk|
        video_id = talk["video_id"]
        next if video_id.nil? || video_id == "" || talk["video_provider"] == "parent"

        talks_slugs[video_id] = talk.dig("slug")
      end

      current_page += 1
      total_pages = parsed_response.dig("pagination", "total_pages")
      break if parsed_response.dig("pagination", "next_page").nil? || current_page > total_pages
    end
    data = {"updated_at" => Time.current.to_date.to_s, "talks_slugs" => talks_slugs}.to_yaml
    File.write("data/talks_slugs.yml", data)
  end

  desc "add slug to talks"
  task add_slug_to_talks: :environment do
    puts "Fetching talks slugs from API"
    talks_slugs = YAML.load_file(TALKS_SLUGS_FILE).dig("talks_slugs")
    paths = Dir.glob("data/**/*/videos.yml")

    paths.each do |videos_yml_path|
      puts "Adding slug to #{videos_yml_path}"
      yaml_content = File.read(videos_yml_path)

      updated_yaml_content = YmlFormatter.add_slug_to_talks(yaml_content, talks_slugs)
      File.write(videos_yml_path, updated_yaml_content)
    end

    # then we ensure the style is correct with prettier
    system("yarn format:yml")
  end
end
