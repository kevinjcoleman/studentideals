class BizHour < ActiveRecord::Base
  belongs_to :business

  validates_presence_of :open_at, :close_at, :day, :business, :timezone
  validates_uniqueness_of :business_id, scope: :day

  enum day: [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
  enum timezone: [:pst, :mst, :cst, :est]

  def open?
    Time.current.between?(Time.parse(open_at).in_time_zone, Time.parse(close_at).in_time_zone)
  end


end
