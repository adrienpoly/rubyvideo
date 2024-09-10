# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: connected_accounts
#
#  id           :integer          not null, primary key
#  uid          :string
#  provider     :string
#  username     :string
#  user_id      :integer          not null
#  access_token :string
#  expires_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# rubocop:enable Layout/LineLength
class ConnectedAccount < ApplicationRecord
  belongs_to :user
end
