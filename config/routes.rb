Rails.application.routes.draw do
  match "/404" => "errors#error404", via: [ :get, :post, :patch, :delete ]
  get 'iframe/search_box'

  # This allows signups to be created through the popup form.
  resources :signups, only: [:create]

  # Return json for search bar.
  get 'search/results'
  get 'search/locations'
  get 'search/bizcats'
  get 'search/redirect'
  get 'search/closest_region', as: 'closest_region'
  get 'region/:region_id/search_terms/:id', to: 'search_terms#show', as: 'region_and_search_term'

  # Devise config.
  devise_for :admins,controllers: {
      registrations: 'registrations/registrations'
  }

  # Reroute admin traffic to RailsAdmin Engine.
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # Currently the region only shows and has an index, it also has nested routes for category and category+subcategory.
  resources :region, only: [:show, :index] do
    get "category/:id", to: "categories#show", as: 'and_category'
    get "category/:category_id/sub_category/:id", to: "categories#sub_show", as: 'category_and_subcategory'
    get "businesses/:business_id", to: "businesses#redirect", as: "region_business_redirect"
  end

  resources :businesses, only: [:show]

  # Click through category to the most deep subcategory
  get 'category/:id' => "categories#list", as: 'category'
  resources :category, only: [] do
    get "sub_category/:id", to: "categories#sub_list", as: 'and_subcategory'
  end

  # Click through states to category & subcategory.
  get 'states/:state_code' => "states#show", as: 'state'
  get 'states/:state_code/category/:category_id' => "states#show_state_and_category", as: 'state_and_category'
  get 'states/:state_code/category/:category_id/subcategory/:sub_category_id' => "states#show_state_category_and_subcategory", as: 'state_category_and_subcategory'

  # Testing for geocoding, only works in dev currently.
  get 'geocoder_test/test' => 'geocoder_test#test', as: 'geocoder_test'
  get 'geocoder_test/geolocation' => 'geocoder_test#geolocation_api', as: 'geocoder_api'

  root 'pages#home'
  get '/coverage', :to => redirect('coverage/index.html')
end
