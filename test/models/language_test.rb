require "test_helper"

class LanguageTest < ActiveSupport::TestCase
  test "all" do
    assert_equal Hash, Language.all.class
    assert_equal 184, Language.all.length
  end

  test "all lookup" do
    assert_equal "English", Language.all["en"]
    assert_equal "French", Language.all["fr"]
    assert_equal "German", Language.all["de"]
    assert_equal "Japanese", Language.all["ja"]
    assert_equal "Portuguese", Language.all["pt"]
    assert_equal "Spanish", Language.all["es"]
  end

  test "alpha2_codes" do
    assert_equal Array, Language.alpha2_codes.class
    assert_equal 184, Language.alpha2_codes.length
  end

  test "english_names" do
    assert_equal Array, Language.english_names.class
    assert_equal 184, Language.english_names.length
  end

  test "find by full name" do
    assert_equal "en", Language.find("English").alpha2
    assert_equal "en", Language.find("english").alpha2

    assert_equal "ja", Language.find("Japanese").alpha2
    assert_equal "ja", Language.find("japanese").alpha2

    assert_nil Language.find("random")
    assert_nil Language.find("nonexistent")
  end

  test "find by alpha2 code" do
    assert_equal "English", Language.find("en").english_name
    assert_equal "English", Language.find("en").english_name

    assert_equal "Japanese", Language.find("ja").english_name
    assert_equal "Japanese", Language.find("ja").english_name
  end

  test "find by alpha3 code" do
    assert_equal "English", Language.find("eng").english_name
    assert_equal "English", Language.find("eng").english_name

    assert_equal "Japanese", Language.find("jpn").english_name
    assert_equal "Japanese", Language.find("jpn").english_name
  end

  test "used" do
    assert_equal 1, Language.used.length
    assert_equal ["en"], Language.used.keys

    talk = talks.two
    talk.language = "Spanish"
    talk.save

    assert_equal 2, Language.used.length
    assert_equal ["en", "es"], Language.used.keys
  end
end
