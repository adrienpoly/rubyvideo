class WatchListTalksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_watch_list

  def create
    @talk = Talk.find(params[:talk_id])
    @watch_list.talks << @talk
    redirect_back fallback_location: @watch_list
  end

  def destroy
    @talk = @watch_list.talks.find(params[:id])
    WatchListTalk.find_by(talk_id: @talk.id, watch_list_id: @watch_list.id).destroy
    redirect_back fallback_location: @watch_list
  end

  private

  def set_watch_list
    @watch_list = Current.user.watch_lists.find(params[:watch_list_id])
  end
end
