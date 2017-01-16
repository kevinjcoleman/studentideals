namespace :cleanup_scripts do
  task import_hours: [:file_name] => [:environment] do |t, args|
    HoursImporter.new(args[:file_name])
  end
end
