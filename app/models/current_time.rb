class CurrentTime
  attr_accessor :time

  def initialize(time=Time.current)
    @time = time
  end

  def with_time_zone
    time.strftime("%T+#{time_zone_formatted}")
  end

  private
    def time_zone_formatted
      time.strftime("%z").gsub(/^-|00$/, "")
    end
end
