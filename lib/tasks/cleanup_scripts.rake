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

  task update_cached_counts: :environment do
    count = Region.count
    Region.find_each do |biz|
      count -= 1; p count if count % 100 == 0
      biz.cache_biz_count
    end
  end

  task add_regions: :environment do
    Business.without_region.find_each do |business|
      business.add_region 
    end
  end
end
