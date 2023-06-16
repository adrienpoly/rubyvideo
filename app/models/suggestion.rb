# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: suggestions
#
#  id               :integer          not null, primary key
#  content          :text
#  status           :integer          default("pending"), not null
#  suggestable_type :string           not null
#  suggestable_id   :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# rubocop:enable Layout/LineLength
class Suggestion < ApplicationRecord
  # associations
  belongs_to :suggestable, polymorphic: true

  # attributes
  serialize :content, coder: JSON

  # callbacks

  # enums
  enum status: {pending: 0, approved: 1, rejected: 2}

  def approved!
    suggestable.update!(content)
    super
  end

  def notice
    if approved?
      "Suggestion approved!"
    elsif rejected?
      "Suggestion rejected!"
    else
      "Your suggestion was successfully created and will be reviewed soon."
    end
  end
end
