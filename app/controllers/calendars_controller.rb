class CalendarsController < ApplicationController
  before_action :set_trakt, except: [:home, :authorize, :get_token, :public_calendar]

  def index
    @trakt_user=@trakt.user_settings
    @user=User.find_by(username: @trakt_user["user"]["ids"]["slug"])

    @cal = Icalendar::Calendar.new
    @cal.publish
    @cal.append_custom_property("X-WR-CALNAME","My Shows")
    respond_to do |format|
      # format.html {@body=@trakt.get_calendar}
      format.html {@body=@trakt.get_calendar(Date.today-31.days,31)+@trakt.get_calendar+@trakt.get_calendar(Date.today+30.days,30)+@trakt.get_calendar(Date.today+60.days,30)+@trakt.get_calendar(Date.today+90.days,30)} #trakt api can only send up to 31 days of events
      format.ics do
        @calendar=set_calendar(@user)
        @body=@trakt.get_calendar(Date.today-31.days,31)+@trakt.get_calendar+@trakt.get_calendar(Date.today+30.days,30)+@trakt.get_calendar(Date.today+60.days,30)+@trakt.get_calendar(Date.today+90.days,30) #trakt api can only send up to 31 days of events
        @body.each do |show|
          event = Icalendar::Event.new
          event.dtstart     = begin_date(show)
          event.dtend       = end_date(show)
          event.summary     = show_title(show)+ " " + episode_number(show) + " - " + episode_title(show)
          event.description = episode_overview(show) + "\n\n" + episode_url(show)
          event.url = episode_url(show)
          @cal.add_event(event)
        end
        @events=@cal.to_ical
        render plain: @events
        @calendar.events=@events
        @calendar.save
      end
    end
  end

  def public_calendar
    respond_to do |format|
      format.ics do
        @cal = Icalendar::Calendar.new
        @cal.publish
        @cal.append_custom_property("X-WR-CALNAME","My Shows")
        @user=User.find_by(username: params[:user_slug])
        @trakt = Trakt.new(@user.trakt_token)

        if params[:user_uuid] == @user.user_uuid
          @calendar=set_calendar(@user)
          @body=@trakt.get_calendar(Date.today-31.days,31)+@trakt.get_calendar+@trakt.get_calendar(Date.today+30.days,30)+@trakt.get_calendar(Date.today+60.days,30)+@trakt.get_calendar(Date.today+90.days,30) #trakt api can only send up to 31 days of events
          @body.each do |show|
            event = Icalendar::Event.new
            event.dtstart     = begin_date(show)
            event.dtend       = end_date(show)
            event.summary     = show_title(show)+ " " + episode_number(show) + " - " + episode_title(show)
            event.description = episode_overview(show) + "\n\n" + episode_url(show)
            event.url = episode_url(show)
            @cal.add_event(event)
          end
          @events=@cal.to_ical
          @calendar.events=@events
          @calendar.save
          render plain: @user.calendar.events
        end
      end
    end
  end


  private

  def set_trakt
    @trakt = Trakt.new(cookies[:token])
  end

  def episode_title(show)
    show["episode"]["title"] ? show["episode"]["title"] : "No title"
  end

  def show_title(show)
    show["show"]["title"]
  end

  def episode_number(show)
    "S"+show["episode"]["season"].to_s.rjust(2, "0")+"E"+show["episode"]["number"].to_s.rjust(2, "0")
  end

  def episode_overview(show)
    show["episode"]["overview"] ? show["episode"]["overview"] : "No overview"
  end

  def begin_date_str(show)
    DateTime.parse(show["first_aired"]).strftime("%d/%m/%Y %I:%M%P")
  end

  def begin_date(show)
    DateTime.parse(show["first_aired"])
  end

  def end_date_str(show)
    (DateTime.parse(show["first_aired"]) + show["episode"]["runtime"].minutes).strftime("%d/%m/%Y %I:%M%P")
  end

  def end_date(show)
    DateTime.parse(show["first_aired"]) + show["episode"]["runtime"].minutes
  end

  def set_calendar(user)
    Calendar.where(user_id: user.id).first_or_create
  end

  def episode_url(show)
    "https://trakt.tv/shows/" + show["show"]["ids"]["slug"]+"/seasons/" +
      show["episode"]["season"].to_s + "/episodes/" + show["episode"]["number"].to_s
  end
end
