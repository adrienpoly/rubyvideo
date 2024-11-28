class Speakers::EnhanceController < ApplicationController
  def update
    @speaker = Speaker.find_by(slug: params[:slug])

    Speaker::EnhanceProfileJob.perform_later(speaker: @speaker) if @speaker.github.present?
    Speaker::FetchBskyMetadata.perform_later(speaker: @speaker) if @speaker.bsky.present?

    flash[:notice] = "Speaker profile will be updated soon."

    respond_to do |format|
      format.turbo_stream
    end
  end
end
