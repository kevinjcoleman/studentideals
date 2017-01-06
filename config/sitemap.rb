# Set the host name for URL creation
if Rails.env.development?
  SitemapGenerator::Sitemap.default_host = "http://localhost"
else
  SitemapGenerator::Sitemap.default_host = "http://deals.studentideals.com"
end




SitemapGenerator::Sitemap.create do
  @categories = SidCategory.all
  @states = Business.where("state IS NOT NULL").group("state").select("state, count(id) as count").order("count DESC").limit(5)

  def add_subcategories_children(sub_category, state, category)
    add state_category_and_subcategory_path(state.state, category, sub_category)
    if sub_category.children.first
      sub_category.children.left_outer_join_businesses.with_taggings.where(businesses: {state: state.state}).find_each do |sub_sub_category|
       add state_category_and_subcategory_path(state.state, category, sub_sub_category)
       add_subcategories_children(sub_sub_category, state, category)
      end
    end
  end

  #Link to intial states show.
  @states.each do |state|
    add state_path(state.state)
  end

  #Link to state's cities and state's categories. ##states/show

  #State categories.
  @states.each do |state|
    SidCategory.with_businesses.where(businesses: {state: state.state}).each do |category|
      add state_and_category_path(state.state, category)
    end
  end

  #State cities.
  @states.each do |state|
    Business.group_by_city.where(state: state.state).each do |city|
      region = Region.where(city: city.city, state: state.state).first
      next unless region
      add region_path(region)
    end
  end

  #Link to state's subcategories. ##state/show_state_and_category
  #State sub_categories.
  @states.each do |state|
    SidCategory.with_businesses.where(businesses: {state: state.state}).each do |category|
      category.sub_categories.roots.left_outer_join_businesses.with_taggings.where(businesses: {state: state.state}).find_each do |sub_category|
        add_subcategories_children(sub_category, state, category)
      end
    end
  end

  #Categories show path.
  @categories.each do |category|
    add category_path(category)
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
