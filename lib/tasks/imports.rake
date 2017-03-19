namespace :imports do
  task :hours, [:file_name] => [:environment] do |t, args|
    HoursImporter.new("lib/assets/#{args[:file_name]}").import!
  end

  task :load_categories, [:file_name] => [:environment] do |t, args|
    CategoryLoader.new("lib/assets/#{args[:file_name]}").import!
  end
end
