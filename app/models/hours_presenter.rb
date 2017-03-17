class HoursPresenter
  attr_accessor :hours, :timezone
  DAYS_OF_THE_WEEK = %w(monday
                        tuesday
                        wednesday
                        thursday
                        friday
                        saturday
                        sunday)

  def initialize(hours, timezone)
    @hours = hours.order(:open_at)
    @timezone = timezone
    set_timezone
  end

  def each_with_hour_order
    DAYS_OF_THE_WEEK.each do |day|
      hours_for_day = hours.select {|h| h.day == day }
      yield(hours_for_day, day)
    end
  end

  def display_hours
    display_hours = ""
    each_with_hour_order {|hour, day| display_hours << output_hour(hour, day)}
    display_hours.html_safe
  end

  def output_hour(hours_for_day=nil, day)
    if hours_for_day.any?
      day = wrap_in_tags("strong", hours_for_day.first.day_display)
      hours_for_display = hours_for_day.map do |hour|
        "#{hour.open_at_display} - #{hour.close_at_display}"
      end.join(", ")
      open_tag = if hours_for_day.first.today?
        hours_for_day.first.business.open? ? wrap_in_tags("span", " Open now", "text-success lead") : wrap_in_tags("span", " Closed now", 'text-danger lead')
      else
        nil
      end
      return wrap_in_tags("p", "#{day} #{hours_for_display}#{open_tag}\n")
    else
      "<p><strong>#{day.match(/^(\w{3})/)[1].titlecase}</strong> Closed</p>\n".html_safe
    end
  end

  def wrap_in_tags(tag, text, css_class=nil)
    display_class = css_class ? " class=\"#{css_class}\"" : ""
    "\n<#{tag}#{display_class}>#{text}</#{tag}>".html_safe
  end

  def set_timezone
    Time.zone = timezone if timezone != Time.zone.name
  end
end
