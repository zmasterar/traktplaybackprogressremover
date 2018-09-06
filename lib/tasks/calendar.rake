task :calendar => :environment do
  User.all.each do |user|
    p user
    trakt=Trakt.new(user.trakt_token)
    p trakt.user_settings["user"]["ids"]["slug"]
    body=trakt.get_calendar(Date.today-30.days,30)+trakt.get_calendar+trakt.get_calendar(Date.today+31.days,31)
    p body
    @cal = Icalendar::Calendar.new
    @cal.publish
    @cal.append_custom_property("X-WR-CALNAME","My Shows")
    body.each do |show|
      event = Icalendar::Event.new
      event.dtstart     = DateTime.parse(show["first_aired"]).new_offset("-3:00")
      event.dtend       = DateTime.parse(show["first_aired"]).new_offset("-3:00")+ show["episode"]["runtime"].minutes
      event.summary     = show["show"]["title"]+ " " + "S"+show["episode"]["season"].to_s.rjust(2, "0")+"E"+show["episode"]["number"].to_s.rjust(2, "0")
      @cal.add_event(event)
    end
    events=@cal.to_ical
    p events
    c = Calendar.where(user_id: user.id).first_or_create
    c.events=events
    c.save
  end

end