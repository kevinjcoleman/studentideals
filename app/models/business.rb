class Business < ActiveRecord::Base
  validates :biz_name, length: { minimum: 3 }, presence: true
  belongs_to :sid_category

  def before_import_save(record)
    self.add_sid_category(record[:sid_category_data]) if record[:sid_category_data]
  end

  def add_sid_category(id)
    category = SidCategory.find_by(sid_category_id: id)
    binding.pry
    self.sid_category_id = category.id
  end
end
