class Language
  DEFAULT = "en".freeze
  ALL_ALPHA2_CODES = ISO_639::ISO_639_1.map(&:alpha2).freeze
  ALL_ENGLISH_NAMES = ISO_639::ISO_639_1.map { |language| language.english_name.split(";").first }.freeze
  ALL_LANGUAGES = ALL_ALPHA2_CODES.zip(ALL_ENGLISH_NAMES).to_h.freeze

  def self.find(term)
    ISO_639
      .search(term)
      .reject { |result| result.alpha2.blank? }
      .first
  end

  def self.alpha2_codes
    ALL_ALPHA2_CODES
  end

  def self.english_names
    ALL_ENGLISH_NAMES
  end

  def self.all
    ALL_LANGUAGES
  end

  def self.by_code(code)
    ALL_LANGUAGES[code]
  end

  def self.used
    assigned_languages = Talk.distinct.pluck(:language)

    Language.all.dup.keep_if { |key, value| assigned_languages.include?(key) }
  end
end
