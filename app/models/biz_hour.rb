class BizHour < ActiveRecord::Base
  belongs_to :business

  validates_presence_of :open_at, :close_at, :day, :business, :timezone
  validates_uniqueness_of :business_id, scope: :day

  enum day: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
  enum timezone: [:pst, :mst, :cst, :est]

  scope :today, -> {where(day: CurrentTime.new.dow)}

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
end
