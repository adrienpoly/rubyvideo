require "test_helper"

class SpeakerTest < ActiveSupport::TestCase
  test "valid_website_url preserve the website url if already valid" do
    speaker = Speaker.new(website: "https://www.google.com")
    assert_equal "https://www.google.com", speaker.valid_website_url
  end

  test "valid_website_url add https to the website if it is not present" do
    speaker = Speaker.new(website: "www.google.com")
    assert_equal "https://www.google.com", speaker.valid_website_url
  end

  test "valid_website_url convert http to https" do
    speaker = Speaker.new(website: "http://www.google.com")
    assert_equal "https://www.google.com", speaker.valid_website_url
  end

  test "valid_website_url returns # if website is blank" do
    speaker = Speaker.new(website: "")
    assert_equal "#", speaker.valid_website_url
  end

  test "speaker user association" do
    speaker = speakers(:one)
    user = users(:one)
    user.update(github_handle: speaker.github)
    assert_equal user.github_handle, speaker.github
    assert_equal user, speaker.user
    assert_equal speaker, user.speaker
  end

  test "normalizes github with URL" do
    assert_equal "username", Speaker.new(github: "https://github.com/username").github
    assert_equal "username", Speaker.new(github: "http://github.com/username").github
    assert_equal "username", Speaker.new(github: "http://www.github.com/username").github
    assert_equal "username", Speaker.new(github: "@username").github
    assert_equal "username", Speaker.new(github: "github.com/username").github
  end

  test "normalizes Twitter with URL" do
    assert_equal "username", Speaker.new(twitter: "https://twitter.com/username").twitter
  end

  test "normalizes Twitter with handle" do
    assert_equal "username", Speaker.new(twitter: "username").twitter
  end

  test "normalizes X.com" do
    assert_equal "username", Speaker.new(twitter: "https://x.com/username").twitter
  end

  test "normalizes bsky (bsky.social)" do
    assert_equal "username.bsky.social", Speaker.new(bsky: "https://bsky.app/profile/username.bsky.social").bsky
  end

  test "normalizes bsky with handle (bsky.social)" do
    assert_equal "username.bsky.social", Speaker.new(bsky: "username.bsky.social").bsky
  end

  test "normalizes bsky (custom domain)" do
    assert_equal "username.dev", Speaker.new(bsky: "https://bsky.app/profile/username.dev").bsky
  end

  test "normalizes bsky with handle (custom domain)" do
    assert_equal "username.dev", Speaker.new(bsky: "username.dev").bsky
  end

  test "normaliezs mastodon (mastodon.social)" do
    assert_equal "https://mastodon.social/@username", Speaker.new(mastodon: "https://mastodon.social/@username").mastodon
  end

  test "normalizes mastodon with handle (mastodon.social)" do
    assert_equal "https://mastodon.social/@username", Speaker.new(mastodon: "@username@mastodon.social").mastodon
  end

  test "normalizes mastodon (ruby.social)" do
    assert_equal "https://ruby.social/@username", Speaker.new(mastodon: "https://ruby.social/@username").mastodon
  end

  test "normalizes mastodon with handle (ruby.social)" do
    assert_equal "https://ruby.social/@username", Speaker.new(mastodon: "@username@ruby.social").mastodon
  end

  test "normalizes linkedin with url" do
    assert_equal "username", Speaker.new(linkedin: "https://linkedin.com/in/username").linkedin
  end

  test "normalizes linkedin with slug" do
    assert_equal "username", Speaker.new(linkedin: "username").linkedin
  end
end
