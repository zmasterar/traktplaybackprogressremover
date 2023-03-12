class Thetvdb
  include HTTParty
  #debug_output $stdout
  base_uri 'https://api.thetvdb.com'
  attr_reader :token

  def initialize
    @headers = {"Content-Type": "application/json", "Accept": "application/json"}
    @apikey = Rails.application.credentials[:production][:thetvdb_apikey]
    @username = Rails.application.credentials[:production][:thetvdb_username]
    @userkey = Rails.application.credentials[:production][:thetvdb_userkey]
    response = self.class.post('/login', headers: @headers, body: {apikey: @apikey, userkey: @userkey, username: @username}.to_json).parsed_response
    @token = response["token"]
  end

  def get_poster(series_id)
    @headers=@headers.merge({"Authorization": "Bearer #{@token}"})
    response = self.class.get("/series/#{series_id}/images/query", headers: @headers, query: {keyType: "poster"})
    return nil unless response.parsed_response["data"]
    
    thumbnail = response.parsed_response["data"]&.last["thumbnail"]
    "https://www.thetvdb.com/banners/#{thumbnail}"
  end

end 