class Sessions::OmniauthController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  def create
    connected_account = ConnectedAccount.find_or_initialize_by(provider: omniauth.provider, uid: omniauth.uid)

    if connected_account.new_record?
      @user = User.create_with(user_params).find_or_create_by(email: omniauth.info.email)
      connected_account.user = @user
      connected_account.access_token = omniauth.credentials&.try(:token)
      connected_account.username = omniauth.info&.try(:nickname)
      connected_account.save!
    else
      @user = connected_account.user
    end

    if @user.persisted?
      session_record = @user.sessions.create!
      cookies.signed.permanent[:session_token] = {value: session_record.id, httponly: true}

      redirect_to redirect_to_path, notice: "Signed in successfully"
    else
      redirect_to sign_in_path, alert: "Authentication failed"
    end
  end

  def failure
    redirect_to sign_in_path, alert: params[:message]
  end

  private

  def redirect_to_path
    query_params["redirect_to"] || root_path
  end

  def user_params
    {email: omniauth.info.email, password: SecureRandom.base58, verified: true}
  end

  def omniauth_params
    {provider: omniauth.provider, uid: omniauth.uid, username: omniauth.info.try(:nickname)}.compact_blank
  end

  def omniauth
    request.env["omniauth.auth"]
  end

  def query_params
    request.env["omniauth.params"]
  end
end
