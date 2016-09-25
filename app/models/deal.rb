class Deal < ActiveRecord::Base
  self.primary_key = 'deal_id'
  belongs_to :business, foreign_key: "biz_id", primary_key: "biz_id"

  validates :desc_short, presence: :true

  def before_import_save(record)
    self.biz_id = record[:bizd_id]
  end
end
