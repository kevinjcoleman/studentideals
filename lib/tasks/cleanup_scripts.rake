namespace :cleanup_scripts do
  desc "regeocode all businesses and regions with invalid lat/lng."
  task regeocode_all: :environment do
    Business.lat_long_of_zero.update_all(latitude: nil, longitude: nil)
    Region.lat_long_of_zero.update_all(latitude: nil, longitude: nil)
    ungeocoded_count = Business.ungeocoded.count
    p "#{ungeocoded_count.to_s} businesses to geocode."
    Business.ungeocoded.find_each do |biz|
      biz.save
      sleep(3)
    end
    p "#{(ungeocoded_count - Business.ungeocoded.count).to_s} businesses geocoded."
    ungeocoded_count = Region.ungeocoded.count
    p "#{ungeocoded_count.to_s} regions to geocode."
    Region.ungeocoded.find_each do |biz|
      biz.save
      sleep(3)
    end
    p "#{(ungeocoded_count - Region.ungeocoded.count).to_s} regions geocoded."
  end
end
