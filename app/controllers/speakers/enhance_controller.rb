class Speakers::EnhanceController < ApplicationController
  def update
    @speaker = Speaker.find_by(slug: params[:slug])

    # TODO: change back to enhance_all_later!
    @speaker.profile_enhancer.enhance_all!

    flash[:notice] = "Speaker profile will be updated soon."

    respond_to do |format|
      format.turbo_stream
    end
  end
end
