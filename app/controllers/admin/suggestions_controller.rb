module Admin
  class SuggestionsController < ApplicationController
    def index
      @suggestions = Suggestion.pending
    end

    def update
      @suggestion = Suggestion.find(params[:id])
      @suggestion.approved!(approver: Current.user)
      redirect_to admin_suggestions_path
    end

    def destroy
      @suggestion = Suggestion.find(params[:id])
      @suggestion.rejected!
      redirect_to admin_suggestions_path
    end
  end
end
