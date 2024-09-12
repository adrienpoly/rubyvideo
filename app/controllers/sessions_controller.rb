class SessionsController < ApplicationController
  include RemoteModal
  allowed_remote_modal_actions :new

  skip_before_action :authenticate_user!, only: %i[new create]

  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = {value: @session.id, httponly: true}

      redirect_to root_path, notice: "Signed in successfully"
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: "That email or password is incorrect"
    end
  end

  def destroy
    @session.destroy
    redirect_to(root_path, notice: "That session has been logged out")
  end

  private

  def set_session
    @session = Current.user.sessions.find(params[:id])
  end
end
