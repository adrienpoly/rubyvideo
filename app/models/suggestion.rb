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
#  approved_by_id   :integer
#  suggested_by_id  :integer
#
# rubocop:enable Layout/LineLength
class Suggestion < ApplicationRecord
  # associations
  belongs_to :suggestable, polymorphic: true
  belongs_to :approved_by, class_name: "User", optional: true
  belongs_to :suggested_by, class_name: "User", optional: true

  # attributes
  serialize :content, coder: JSON

  # callbacks

  # enums
  enum :status, {pending: 0, approved: 1, rejected: 2}

  # validations
  validates :approved_by, presence: true, if: :approved?

  def approved!(approver:)
    ActiveRecord::Base.transaction do
      suggestable.update!(content)
      update!(status: :approved, approved_by_id: approver.id)
    end
  end

  def notice
    if approved?
      "Modification approved!"
    elsif rejected?
      "Suggestion rejected!"
    else
      "Your suggestion was successfully created and will be reviewed soon."
    end
  end
end
