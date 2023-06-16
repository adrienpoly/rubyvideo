# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: email_verification_tokens
#
#  id      :integer          not null, primary key
#  user_id :integer          not null
#
# rubocop:enable Layout/LineLength
class EmailVerificationToken < ApplicationRecord
  belongs_to :user
end
