# This script will query the API and dump the speakers data to a YAML file
# speaker data can we updated in production, this is a way to sync our seed data to reflect as closely as possible the prod environment

require "net/http"
require "json"
require "yaml"

API_ENDPOINT = "https://www.rubyvideo.dev/speakers.json"
OUTPUT_FILE = "data/speakers.yml"

def fetch_speakers
  speakers = []
  current_page = 1

  loop do
    uri = URI("#{API_ENDPOINT}?page=#{current_page}")
    response = Net::HTTP.get(uri)
    parsed_response = JSON.parse(response)

    speakers.concat(parsed_response["speakers"])
    current_page += 1
    break if parsed_response.dig("pagination", "next_page").nil?
  end

  speakers
end

def save_to_yaml(data)
  File.write(OUTPUT_FILE, data.to_yaml)
end

speakers_data = fetch_speakers
save_to_yaml(speakers_data)

puts "Speakers data saved to #{OUTPUT_FILE}"

puts "formating with Prettier..."

system("yarn prettier --write #{OUTPUT_FILE}")

puts "Done!"
