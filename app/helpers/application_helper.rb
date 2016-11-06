module ApplicationHelper
  include ActionView::Helpers::TagHelper
  FLASH_TYPES = {:success => 'alert-success',
                 :error => 'alert-danger',
                 :alert => 'alert-warning',
                 :notice => 'alert-info'}

  def alert_class_for(flash_type)
    FLASH_TYPES[flash_type.to_sym] || "alert-#{flash_type.to_s}"
  end

  def logo(sid_category_id)
    case sid_category_id
    when SidCategory::MORE.to_s
      fa_icon "rocket"
    when SidCategory::HEALTH.to_s
      fa_icon "heart"
    when SidCategory::SOMETHINGTODO.to_s
      fa_icon "bolt"
    when SidCategory::FOOD.to_s
      fa_icon "glass"
    when SidCategory::SHOPPING.to_s
      fa_icon "shopping-bag"
    else
      fa_icon "question"
    end 
  end       
end
