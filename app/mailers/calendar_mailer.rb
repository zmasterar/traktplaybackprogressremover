class CalendarMailer < ApplicationMailer
  default from: 'Trakt playback progress remover <benja@zmaster.com.ar>'
  
  def test
    mail(to: "benja@zmaster.com.ar", subject: 'Test mail')
  end

  def today_shows(mail, shows)
    @today_shows=shows
    mail(to: mail, subject: 'Today shows')
  end

  def error_email(mail, error)
    @error=error
    mail(to: mail, subject: 'Today shows Error')
  end
end
