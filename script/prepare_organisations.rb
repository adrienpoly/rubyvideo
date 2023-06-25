# start this script with the rails runner command
# $ rails runner script/prepare_organisations.rb
# it will load the data_tmp/organisations.yml file and add the youtube_channel_id to each organisation
# this simplify the workflow as this id is not always easy to find from the channel name
#

organisations = YAML.load_file("#{Rails.root}/data_tmp/organisations.yml")

# add youtube_channel_id to organisations if missing
organisations.map! do |organisation|
  organisation["slug"] ||= organisation["name"].parameterize
  organisation["youtube_channel_id"] ||= Youtube::Channels.new.id_by_name(channel_name: organisation["youtube_channel"])
  organisation
end

# save the Youtube channel id to the data_tmp/organisations.yml file
File.write("#{Rails.root}/data_tmp/organisations.yml", organisations.to_yaml)
