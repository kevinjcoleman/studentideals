class HoursPresenter
  attr_accessor :hours
  DAYS_OF_THE_WEEK = %w(monday
                        tuesday
                        wednesday
                        thursday
                        friday
                        saturday
                        sunday)

  def initialize(hours)
    @hours = hours
  end

  def each_with_hour_order
    DAYS_OF_THE_WEEK.each do |day|
      hour = hours.find {|h| h.day == day }
      yield(hour, day)
    end
  end

  def display_hours
    display_hours = ""
    each_with_hour_order {|hour, day| display_hours << output_hour(hour, day)}
    display_hours.html_safe
  end

  def output_hour(hour=nil, day)
    if hour
      day = wrap_in_tags("strong", hour.day_display)
      hours = "#{hour.open_at_display} - #{hour.close_at_display}"
      open_for_display = if hour.today?
        hour.open? ? wrap_in_tags("span", " Open now", "text-success lead") : wrap_in_tags("span", " Closed now", 'text-danger lead')
      else
        nil
      end
      wrap_in_tags("p", "#{day} #{hours}#{open_for_display}\n")
    else
      "<p><strong>#{day.match(/^(\w{3})/)[1].titlecase}</strong> Closed</p>\n".html_safe
    end
  end

  def wrap_in_tags(tag, text, css_class=nil)
    display_class = css_class ? " class=\"#{css_class}\"" : ""
    "\n<#{tag}#{display_class}>#{text}</#{tag}>".html_safe
  end
end
