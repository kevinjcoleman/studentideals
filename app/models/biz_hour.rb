class BizHour < ActiveRecord::Base
  belongs_to :business

  validates_presence_of :open_at, :close_at, :day, :business, :timezone

  enum day: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
  enum timezone: [:pst, :mst, :cst, :est]

  TIMEZONES = {"est" => "-05",
               "pst" => "-08"}

  scope :today, -> {where(day: CurrentTime.new.dow)}
  scope :hours_between, -> (open_hour, close_hour) {where("(open_at <= '#{open_hour}' AND close_at >= '#{open_hour}') OR (open_at <= '#{close_hour}' AND close_at >= '#{close_hour}')")}

  def open?
    Time.current.between?(Time.parse(open_at).in_time_zone, Time.parse(close_at).in_time_zone)
  end

  def open_at_display
    display_time(open_at)
  end

  def close_at_display
    display_time(close_at)
  end

  def today?
    read_attribute("day") == CurrentTime.new.dow
  end

  def display_time(time)
    Time.parse(time).in_time_zone.strftime("%I:%M %P")
  end

  def day_display
    day.match(/^(\w{3})/)[1].titlecase
  end

  def self.add_hour(hour, biz)
    parsed_hour = factual_hour_hash(hour, biz)
    return if biz.hours.where(day: parsed_hour[:day]).hours_between(parsed_hour[:open_at], parsed_hour[:close_at]).any?
    create!(parsed_hour)
  end

  def self.factual_hour_hash(hour, biz)
    timezone = TIMEZONES[biz.timezone]
    {day: self.days[hour[0]],
     open_at: "#{hour[1][0][0]}#{timezone}",
     close_at: "#{hour[1][0][1]}#{timezone}",
     timezone: biz.timezone,
     business_id: biz.id}
  end
end
