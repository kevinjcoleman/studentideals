class Color
  attr_accessor :color
  COLORS = {
    blue: "#229AD6",
    orange: "#FF9000"
  }
  def initialize(color)
    @color = color
  end

  def self.fetch_color(color)
    instance = new(color)
    instance.valid_color?
    COLORS[instance.color.to_sym]
  end

  def valid_color?
    raise ArgumentError, "That's not a currently supported color." unless color.to_sym.in? COLORS.keys
  end
end