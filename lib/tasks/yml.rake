require_relative "../yml_formatter"

namespace :yml do
  desc "normalize the yml file"
  task normalize: :environment do
    Dir.glob("data/**/*/videos.yml").each do |videos_yml_path|
      # first we normalize the comments
      puts videos_yml_path
      yaml_content = File.read(videos_yml_path)
      reformatted_content = YmlFormatter.normalize_comment_lines(yaml_content)

      # then we normalize the content
      reformatted_content = YmlFormatter.normalize_commented_yaml_file(reformatted_content)
      File.write(videos_yml_path, reformatted_content)
    end

    # then we ensure the style is correct with prettier
    system("yarn format:yml")
  end
end
