if @results.first.is_a?(PgSearch::Document)
  json.locations @results.each do |result|
    json.label result.content
    json.type result.searchable.type
  end
else
  json.locations @results.each do |result|
    json.label result.name
    json.type result.type
  end
end
