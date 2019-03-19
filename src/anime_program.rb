class AnimeProgram
  attr_reader :channel, :title, :date, :week, :time

  def initialize(channel, title, date, week, time, planned)
    @channel = channel
    @title = title
    @date = date
    @week = week
    @time = time
    @planned = planned
  end

  def planned?
    @planned
  end
end
