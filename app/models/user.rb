# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  verified        :boolean          default(FALSE), not null
#  admin           :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  name            :string
#
# rubocop:enable Layout/LineLength
class User < ApplicationRecord
  has_secure_password

  has_many :email_verification_tokens, dependent: :destroy
  has_many :password_reset_tokens, dependent: :destroy
  has_many :sessions, dependent: :destroy, inverse_of: :user
  has_many :connected_accounts, dependent: :destroy
  has_many :watch_lists, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, allow_nil: true, length: {minimum: 6}
  validates :github_handle, presence: true, uniqueness: true

  encrypts :email, deterministic: true
  encrypts :name

  before_validation if: -> { email.present? } do
    self.email = email.downcase.strip
  end

  before_validation if: :email_changed?, on: :update do
    self.verified = false
  end

  after_update if: :password_digest_previously_changed? do
    sessions.where.not(id: Current.session).delete_all
  end

  def default_watch_list
    watch_lists.first || watch_lists.create(name: "Favorites")
  end
end
