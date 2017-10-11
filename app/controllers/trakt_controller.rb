class TraktController < ApplicationController
  require "trakt"
  before_action :set_trakt, except: [:home, :authorize, :get_token]

  def home
  end

  def authorize
    redirect_to "https://trakt.tv/oauth/authorize?response_type=code&client_id=#{ENV["TRAKT_CLIENT_ID"]}&redirect_uri=http://localhost:3000/token"
  end

  def get_token
    @trakt = Trakt.new
    response = @trakt.get_token(params[:code])
    cookies[:token]=response.parsed_response["access_token"]
    redirect_to root_path, notice: "Authenticated!"
  end

  def delete_token
    @trakt.delete_token
    cookies.delete :token
    redirect_to root_path, notice: "Access revoked!"
  end

  def playback
    response = @trakt.playback
    @body=response.parsed_response
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
