if @results.first.is_a?(PgSearch::Document)
  json.locations @results.each do |result|
    json.label result.content
  end
else
  json.locations @results.each do |result|
    json.label result.name
  end
end
