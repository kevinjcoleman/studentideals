if @results.first.is_a?(PgSearch::Document)
  json.locations @results.each do |result|
    json.id result.searchable.id
    json.label result.content
    json.type result.searchable.type
  end
else
  json.locations @results.each do |result|
    json.id result.id
    json.label result.name
    json.type result.type
  end
end
