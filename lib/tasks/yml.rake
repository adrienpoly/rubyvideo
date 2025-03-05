require_relative "../yml_formatter"

namespace :yml do
  desc "normalize the yml file"
  task normalize: :environment do
    Dir.glob("data/**/*/videos.yml").each do |videos_yml_path|
      YmlFormatter.normalize_commented_yaml_file(videos_yml_path)

      # first we normalize the comments
      yaml_content = File.read(videos_yml_path)
      reformatted_content = YmlFormatter.normalize_comment_lines(yaml_content)

      # then we normalize the content
      # reformatted_content = YmlFormatter.normalize_content_lines(reformatted_content)
      File.write(videos_yml_path, reformatted_content)
    end

    # then we ensure the style is correct with prettier
    system("yarn format:yml")
  end

  desc "normalize comments empty lines"
  task normalize_comments_empty_lines: :environment do
    Dir.glob("data/**/*/videos.yml").each do |videos_yml_path|
      lines = File.readlines(videos_yml_path, chomp: true)
      reformatted_content = YmlFormatter.normalize_comment_lines(lines)
      File.write(videos_yml_path, reformatted_content + "\n")
    end
  end
end
