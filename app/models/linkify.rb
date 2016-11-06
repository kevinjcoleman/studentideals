class Linkify
  attr_accessor :background
  
  def initialize(background)
    @background = background
  end

  def add_links
    parse.map do |word|
      modify!(word)
    end.join(" ")
  end

  def parse
    background.split(' ')
  end

  def modify!(string)
    return string unless uri?(string)
    %Q[<a href="#{string}" target="_blank">#{string}</a>]
  end

  def uri?(string)
      uri = URI.parse(string)
      uri.scheme.in? %w(http https)
    rescue URI::InvalidURIError
      false
  end
end