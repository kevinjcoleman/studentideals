class HoursImporter
  attr_accessor :file_name
  def initialize(file_name)
    @file_name = file_name
  end

  def import!
    CSV.foreach(filename, headers: true) do |row|
      row_hash = row_hash(row)
      business = Business.find_by_biz_id(row_hash[:biz_id])
      business.add_business_hours(row_hash(row).except(:biz_id))
    end
  end

  def biz_id(row)
    row["biz_keyid"]
  end

  def row_hash(row)
    {biz_id: row["biz_keyid"],
     day: row["biz_day"],
     open_at: row["biz_open"],
     close_at: row["biz_close"]}
  end
end
