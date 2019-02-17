class CalendarMailer < ApplicationMailer
  default from: 'benja@zmaster.com.ar'
  
  def test
    mail(to: "benja@zmaster.com.ar", subject: 'Test mail')
  end

  def today_shows
    user = User.first
    trakt = Trakt.new(user.trakt_token)
    @today_shows = trakt.get_calendar(Date.today.to_s,1)
    mail(to: "benja@zmaster.com.ar", subject: 'Today shows')
  end
end
