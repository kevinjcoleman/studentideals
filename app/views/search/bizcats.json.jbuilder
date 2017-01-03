json.bizcats (@categories + @businesses).each do |result|
  if result.is_a?(PgSearch::Document)
    json.id result.searchable.id
    json.label result.content
    json.type result.searchable_type
  else
    json.id result.id
    json.label result.biz_name
    json.type "Business"
  end
end
