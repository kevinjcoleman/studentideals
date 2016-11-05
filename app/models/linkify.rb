class Linkify
  attr_accessor :background
  
  def initialize(background)
    @background = background
  end

  def add_links
    parse.map do |word|
      word
    end.join(" ")
  end

  def parse
    background.split(' ')
  end
end