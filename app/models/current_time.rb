class CurrentTime
  attr_accessor :time

  def initialize(time=Time.zone.now)
    @time = time
  end

  def with_time_zone
    time.strftime("%T+#{time_zone_formatted}")
  end

  def time_for_search
    time.strftime("%T-#{time_zone_formatted}")
  end
    
  def dow
    Time.current.strftime("%w").to_i
  end

  private
    def time_zone_formatted
      time.strftime("%z").gsub(/^-|00$/, "")
    end
end
