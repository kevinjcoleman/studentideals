namespace :imports do
  task :hours, [:file_name] => [:environment] do |t, args|
    HoursImporter.new("lib/assets/#{args[:file_name]}").import!
  end
end
