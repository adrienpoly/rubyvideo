class OrganisationsController < ApplicationController
  include Pagy::Backend
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_organisation, only: %i[show]

  # GET /organisations
  def index
    @organisations = Organisation.includes(:events).order(:name)
  end

  # GET /organisations/1
  def show
    set_meta_tags(@organisation)

    @events = @organisation.events.order(date: :desc)

    if @events.first.featurable?
      @featured_event, *@remaning_events = @events
    else
      @remaning_events = @events
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organisation
    @organisation = Organisation.find_by!(slug: params[:slug])
  end
end
