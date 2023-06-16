# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: password_reset_tokens
#
#  id      :integer          not null, primary key
#  user_id :integer          not null
#
# rubocop:enable Layout/LineLength
class PasswordResetToken < ApplicationRecord
  belongs_to :user
end
