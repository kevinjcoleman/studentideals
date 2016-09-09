require "factual"

class FactualClient
  attr_accessor :client

  def initialize
    @client = Factual.new(ENV["factual_key"], ENV["factual_secret"])
  end

  def find_business(factual_id)
    client.table("places-us").row(factual_id)
  end
end