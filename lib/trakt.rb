class Trakt
  include HTTParty
  #debug_output $stdout
  base_uri 'https://api.trakt.tv'

  def initialize(token=nil)
    @headers = {"Content-Type": "application/json", "trakt-api-version": "2"}
    @client_id = ENV["TRAKT_CLIENT_ID"]
    if token
      @headers.merge!({"trakt-api-key": @client_id, "Authorization": "Bearer #{token}"})
      @token = token
    end
    @client_secret = ENV["TRAKT_CLIENT_SECRET"]
    @redirect_uri = Rails.env.production? ? "https://traktprogressremover.herokuapp.com/token" : "http://localhost:3000/token"
  end

  def get_token(code)
    self.class.post('/oauth/token', headers: @headers, query: {client_id: @client_id, code: code, client_secret: @client_secret, redirect_uri: @redirect_uri, grant_type: "authorization_code"}).parsed_response
  end

  def delete_token
    self.class.post('/oauth/revoke', body: { token: @token, client_id: @client_id, client_secret: @client_secret })
        .parsed_response
  end

  def playback
    self.class.get('/sync/playback', headers: @headers).parsed_response
  end

  def delete_playback(id)
    self.class.delete("/sync/playback/#{id}", headers: @headers).parsed_response
  end

  def get_calendar(date_from=Date.today.to_s, days=30) #trakt api can only send up to 31 days of events
    r=self.class.get("/calendars/my/shows/#{date_from}/#{days}?extended=full", headers: @headers)
    puts "Trakt response code: "+r.code.to_s
    r.parsed_response 
  end

  def user_settings
    self.class.get("/users/settings", headers: @headers).parsed_response
  end

end
