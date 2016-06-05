namespace :cleanup_scripts do
  desc "regeocode all businesses and regions with invalid lat/lng."
  task regeocode_all: :environment do
    Business.lat_long_of_zero.update_all(latitude: nil, longitude: nil)
    Region.lat_long_of_zero.update_all(latitude: nil, longitude: nil)
    Business.ungeocoded.find_each(&:save)
    Region.ungeocoded.find_each(&:save)
  end
end
