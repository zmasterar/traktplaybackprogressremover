class TraktController < ApplicationController
  require "trakt"
  before_action :set_trakt, except: [:home, :authorize, :get_token]

  def home
  end

  def authorize
    redirect_to "https://trakt.tv/oauth/authorize?response_type=code&client_id=#{ENV["TRAKT_CLIENT_ID"]}&redirect_uri=#{root_url}token" #root_url defined in /config/environments/production.rb
  end

  def get_token
    @trakt = Trakt.new
    response = @trakt.get_token(params[:code])
    cookies[:token]=response["access_token"]
    set_trakt
    @user = @trakt.user_settings
    u=User.where(username: @user["user"]["username"]).first_or_create(user_uuid: SecureRandom.uuid)
    u.trakt_token=response["access_token"]
    u.save
    redirect_to root_path, notice: "Authenticated!"
  end

  def delete_token
    @user = @trakt.user_settings
    response = @trakt.delete_token
    return redirect_to root_path, notice: "There has been a problem!" unless response.ok?

    User.where(username: @user["user"]["username"]).destroy_all
    cookies.delete :token
    redirect_to root_path, notice: "Access revoked!"
  end

  def playback
    response = @trakt.playback
    @body=response
  end

  def delete_playback
    @trakt.delete_playback(params[:id])
    redirect_to playback_path, notice: "Progress deleted"
  end

  private

  def set_trakt
    @trakt = Trakt.new(cookies[:token])
  end

end
