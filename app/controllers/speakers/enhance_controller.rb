class Speakers::EnhanceController < ApplicationController
  def update
    @speaker = Speaker.find_by(slug: params[:slug])
    Speaker::EnhanceProfileJob.perform_later(speaker: @speaker)

    flash[:notice] = "Speaker profile will be updated soon."
    respond_to do |format|
      format.turbo_stream
    end
  end
end
