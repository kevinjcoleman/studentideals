# Set the host name for URL creation
if Rails.env.development?
  SitemapGenerator::Sitemap.default_host = "http://localhost"
else
  SitemapGenerator::Sitemap.default_host = "http://deals.studentideals.com"
end




SitemapGenerator::Sitemap.create do
  @categories = SidCategory.includes(:sub_categories)
  @states = Business.where("state IS NOT NULL").group("state").select("state, count(id) as count").order("count DESC").limit(5)

  def add_state_subcategories_children(sub_category, state, category)
    add state_category_and_subcategory_path(state.state, category, sub_category)
    if sub_category.children.first
      sub_category.children.left_outer_join_businesses.with_taggings.where(businesses: {state: state.state}).find_each do |sub_sub_category|
       add state_category_and_subcategory_path(state.state, category, sub_sub_category)
       add_state_subcategories_children(sub_sub_category, state, category)
      end
    end
  end

  def add_region_subcategories_children(sub_category, region, category)
    add region_category_and_subcategory_path(region, category, sub_category)
    if sub_category.children.first
      sub_category.children.
        join_and_order_by_taggings_count.
        where(sub_category_taggings: {business_id: sub_category.businesses.nearby(region).pluck(:id)}).find_each do |sub_sub_category|
          add region_category_and_subcategory_path(region, category, sub_sub_category)
          add_region_subcategories_children(sub_sub_category, region, category)
      end
    end
  end

  #Link to intial states show.
  @states.each do |state|
    # Link to states.
    add state_path(state.state)

    # Link to state categories and subcategories.
    SidCategory.with_businesses.where(businesses: {state: state.state}).each do |category|
      add state_and_category_path(state.state, category)
      category.sub_categories.roots.left_outer_join_businesses.with_taggings.where(businesses: {state: state.state}).find_each do |sub_category|
        add_state_subcategories_children(sub_category, state, category)
      end
    end

    # Link to regions in state.
    Region.where(state: state.state).find_each do |region|
      add region_path(region)
      @categories.each do |category|
        # Link to categories for a region if there are businesses of that category nearby.
        next unless category.businesses.nearby(region).present?
        add region_and_category_path(region, category)
        # If a region's category has subcategories link to the subcategories as well.
        if category.sub_categories.first
          category.sub_categories.roots.
            join_and_order_by_taggings_count.
            where(sub_category_taggings: {business_id: category.businesses.nearby(region).pluck(:id)}).find_each do |sub_category|
              add_region_subcategories_children(sub_category, region, category)
          end
        end
      end
    end
  end

  #Categories show path.
  @categories.each do |category|
    add category_path(category)
  end

  Business.find_each do |business|
    add business_path(business)
  end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
