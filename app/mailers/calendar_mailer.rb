class CalendarMailer < ApplicationMailer
  default from: 'Traktplaybackprogressremover <benja@zmaster.com.ar>'
  
  def test
    mail(to: "benja@zmaster.com.ar", subject: 'Test mail')
  end

  def today_shows(mail, shows)
    @today_shows=shows
    mail(to: mail, subject: 'Today shows')
  end
end
