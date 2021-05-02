# frozen_string_literal: true

task calendar: :environment do
  User.all.each do |user|
    p user
    trakt = Trakt.new(user.trakt_token)
    p trakt.user_settings['user']['ids']['slug']
    body = trakt.get_calendar(Date.today - 30.days, 30) +
           trakt.get_calendar + trakt.get_calendar(Date.today + 31.days, 31)
    p body
    @cal = Icalendar::Calendar.new
    @cal.publish
    @cal.append_custom_property('X-WR-CALNAME', 'My Shows')
    body.each do |show|
      event = Icalendar::Event.new
      event.dtstart     = DateTime.parse(show['first_aired']).new_offset('-3:00')
      event.dtend       = DateTime.parse(show['first_aired']).new_offset('-3:00') +
                          show['episode']['runtime'].minutes
      event.summary     = "#{show['show']['title']} S#{show['episode']['season'].to_s.rjust(2, '0')}E"\
                          "#{show['episode']['number'].to_s.rjust(2, '0')}"
      @cal.add_event(event)
    end
    events = @cal.to_ical
    p events
    c = Calendar.where(user_id: user.id).first_or_create
    c.events = events
    c.save
  end
end

task mail_today_shows: :environment do
  puts 'Executed task :mail_today_shows'
  User.all.each do |user|
    trakt = Trakt.new(user.trakt_token)
    mail = trakt.user_settings['user']['location']
    @today_shows = trakt.get_calendar((Date.today + 1).to_s, 1) # Date.today+1 beacuse trakt only works with utc
    if @today_shows.count.positive?
      thetvdb = Thetvdb.new
      @today_shows.map! { |show| show.merge({ poster_url: thetvdb.get_poster(show['show']['ids']['tvdb']) }) }
      CalendarMailer.today_shows(mail, @today_shows).deliver_now
      puts 'Sent mail with today_shows'
      puts 'Today shows:'
      puts @today_shows
    else
      puts 'No shows today'
    end
  end
rescue Net::SMTPAuthenticationError => e
  puts 'Gmail authentication error'
  puts e
rescue => e
  puts 'Oh, No! Something happend'
  mail ||= ENV['WEBMASTER_EMAIL']
  CalendarMailer.today_shows(mail, e).deliver_now
ensure
  puts 'Task ended'
end

task test_mail: :environment do
  puts 'Sending test mail'
  CalendarMailer.error_email('benja@zmaster.com.ar', 'Hubo un error en algún lado').deliver_now
  puts 'Test mail sent'
end
