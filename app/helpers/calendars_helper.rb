module CalendarsHelper
  def user_slug(user)
    user.username
  end

  def user_uuid(user)
    user.user_uuid
  end

  def show_title(show)
    show["show"]["title"]
  end

  def show_url(show)
    "https://trakt.tv/shows/#{show["show"]["ids"]["slug"]}"
  end

  def episode_number(show)
    "S"+show["episode"]["season"].to_s.rjust(2, "0")+"E"+show["episode"]["number"].to_s.rjust(2, "0")
  end

  def episode_overview(show)
    show["episode"]["overview"]
  end

  def episode_url(show)
    "https://trakt.tv/shows/#{show["show"]["ids"]["slug"]}/seasons/#{show["episode"]["season"]}/episodes/#{show["episode"]["number"]}"
  end

  def begin_date_str(show)
    DateTime.parse(show["first_aired"]).new_offset("-3:00").strftime("%d/%m/%Y %I:%M%P")
  end

  def begin_date(show)
    DateTime.parse(show["first_aired"]).new_offset("-3:00")
  end

  def end_date_str(show)
    (DateTime.parse(show["first_aired"]).new_offset("-3:00") + show["episode"]["runtime"].minutes).strftime("%d/%m/%Y %I:%M%P")
  end

  def end_date(show)
    DateTime.parse(show["first_aired"]).new_offset("-3:00") + show["episode"]["runtime"].minutes
  end

end
