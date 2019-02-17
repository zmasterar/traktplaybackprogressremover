class CalendarMailer < ApplicationMailer
  default from: 'benja@zmaster.com.ar'
  
  def test
    mail(to: "benja@zmaster.com.ar", subject: 'Test mail')
  end

  def today_shows
    User.all.each do |user|
      trakt = Trakt.new(user.trakt_token)
      @today_shows = trakt.get_calendar(Date.today.to_s,1)
      mail(to: trakt.user_settings["user"]["location"], subject: 'Today shows')
    end
  end
end
