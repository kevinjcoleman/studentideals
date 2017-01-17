class HoursImporter
  attr_accessor :file_name
  def initialize(file_name)
    @file_name = file_name
  end

  def import!
    CSV.open("tmp/hours_errors.csv", "wb") do |errors|
      CSV.foreach(file_name, headers: true) do |row|
        begin
          row_hash = row_hash(row)
          business = Business.find_by_biz_id(row_hash[:biz_id])
          next unless business
          business.add_business_hours(row_hash(row).except(:biz_id))
        rescue => e
          errors << row.to_hash.values.push(e.message)
          errors.flush
        end
      end
    end
  end

  def biz_id(row)
    row["biz_hrs_id"]
  end

  def row_hash(row)
    {biz_id: row["biz_hrs_id"],
     day: row["biz_day"],
     open_at: row["biz_open"],
     close_at: row["biz_close"]}
  end
end
