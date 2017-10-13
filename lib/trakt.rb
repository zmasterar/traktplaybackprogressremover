class Trakt
  include HTTParty
  #debug_output $stdout 
  base_uri 'https://api.trakt.tv'

  def initialize(token=nil)
    @headers = {"Content-Type": "application/json", "trakt-api-version": "2"}
    @client_id = ENV["TRAKT_CLIENT_ID"]
    if token
      @headers.merge!({"trakt-api-key": @client_id, "Authorization": "Bearer #{token}"})
      @token = token if token
    end
    @client_secret = ENV["TRAKT_CLIENT_SECRET"]
    @redirect_uri = Rails.env.production? ? "https://traktprogressremover.herokuapp.com/token" : "http://localhost:3000/token"
  end

  def get_token(code)
    self.class.post('/oauth/token', headers: @headers, query: {client_id: @client_id, code: code, client_secret: @client_secret, 
                                                                redirect_uri: @redirect_uri, grant_type: "authorization_code"})
  end

  def delete_token
    self.class.post('/oauth/revoke', headers: @headers.merge!({"Content-Type": "application/x-www-form-urlencoded"}), body: {token: @token})
  end

  def playback
    self.class.get('/sync/playback', headers: @headers)
  end

  def delete_playback(id)
    self.class.delete("/sync/playback/#{id}", headers: @headers)
  end
end
