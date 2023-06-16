class CreateEmailVerificationTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :email_verification_tokens do |t|
      t.references :user, null: false, foreign_key: true
    end
  end
end
