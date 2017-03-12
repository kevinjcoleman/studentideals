class DuplicateCategoryFinder
  attr_accessor :duplicate_labels, :roots
  def initialize(roots=true)
    @roots = roots
  end

  def run!
    get_labels
    duplicate_labels.each_with_object({}) {|label, hsh| hsh[label] = SubCategory.where(label: label).map {|s| [s.id, s.sid_category.label]}}
  end

  def get_labels
    if roots
      @duplicate_labels = SubCategory.roots.select("count(id), label").group("label").having("count(id) > 1").map {|r| r.label }
    else
      @duplicate_labels = SubCategory.select("count(id), label").group("label").having("count(id) > 1").map {|r| r.label }
    end
  end
end
