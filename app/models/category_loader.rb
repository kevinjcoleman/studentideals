class CategoryLoader
  attr_accessor :file_name
  def initialize(file_name)
    @file_name = file_name
  end

  def import!
    CSV.open("tmp/category_errors.csv", "wb") do |errors|
      CSV.foreach(file_name, headers: true) do |row|
        begin
          row_hash = row_hash(row)
          business = Business.find_by_biz_id(row_hash[:biz_id])
          next unless business
          SubCategory.create_subcategory_and_tree_from_row(row_hash.except(:biz_id), business)
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
    {biz_id: row["biz_id"],
     metadata_name: row["metadata_name"],
     metadata_value: row["metadata_value"],
     label: row["Label"],
     category_path: row["category_path"]}
  end
end
