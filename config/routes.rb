Rails.application.routes.draw do

  # This allows signups to be created through the popup form.
  resources :signups, only: [:create]

  # Return json for search bar.
  get 'search/results'
  get 'search/locations'

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
    resources :businesses, only: [:show]
  end

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
