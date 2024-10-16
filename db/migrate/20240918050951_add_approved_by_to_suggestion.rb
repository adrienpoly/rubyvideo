class AddApprovedByToSuggestion < ActiveRecord::Migration[7.2]
  def change
    add_reference :suggestions, :approved_by, foreign_key: {to_table: :users}

    initial_approver = User.find_by(email: "adrienpoly@gmail.com") || User.where(admin: true).order(:created_at).first

    if initial_approver
      Suggestion.update_all(approved_by_id: initial_approver.id)
    end
  end
end
