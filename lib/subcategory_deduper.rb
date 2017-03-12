class SubcategoryDeduper
  attr_accessor :duplicate_category, :correct_category

  def initialize(duplicate_category, correct_category)
    @duplicate_category, @correct_category = duplicate_category, correct_category
  end

  # Go through each of the businesses and change each business to the correct sid_category
  # & change the sub_category_taggings to the correct category
  # Then go through each of the sub_categories children
  # 1. Change each business to the correct sid_category if it isn't already
  # 2. If there is another subcategory of the same type, add sub_category_taggings to that subcategory, otherwise change the parent to the original parent.
  # Do the same for each of the additional children of that child.
  # Then destroy it and all of it's children.
  def merge!
    duplicate_category.each_with_children {|subcategory| swap_businesses_and_taggings(subcategory) }
    duplicate_category.destroy
  end

  def swap_businesses_and_taggings(subcategory)
    subcategory.businesses.update_all(sid_category_id: correct_sid_category_id)
    if duplicate_category == subcategory
      new_subcategory_id = correct_category.id
    else
      if existing_duplicate_child = SubCategory.where(label: subcategory.label, sid_category_id: correct_sid_category_id).first
        new_subcategory_id = existing_duplicate_child.id
      else
        switch_subcategory_parent(subcategory)
      end
    end
    subcategory.sub_category_taggings.update_all(sub_category_id: new_subcategory_id) if new_subcategory_id
  end

  def correct_sid_category_id
    @correct_id ||= correct_category.sid_category_id
  end

  def switch_subcategory_parent(subcategory)
    parent_duplicate = SubCategory.where(label: subcategory.parent.label, sid_category_id: correct_sid_category_id).first
    subcategory.update_attributes!(parent: parent_duplicate)
  end
end
