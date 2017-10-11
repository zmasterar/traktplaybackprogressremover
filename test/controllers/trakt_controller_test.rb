require 'test_helper'

class TraktControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get trakt_home_url
    assert_response :success
  end

end
