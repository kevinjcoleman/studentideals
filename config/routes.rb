Rails.application.routes.draw do

  resources :signups, only: [:create]

  get 'search/results'
  get 'search/show'

  devise_for :admins,controllers: {
      registrations: 'registrations/registrations'
  }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'region/show'
  resources :region do
    get :autocomplete_region_name, :on => :collection
    resources :categories, only: [:show]
    resources :businesses, only: [:show]
  end

  get 'category/:id' => "categories#list", as: 'category'
  get 'category/:category_id/sub_category/:id' => "categories#sub_list", as: 'category_and_subcategory'
  get '/region/:region_id/category/:category_id/sub_category/:id' => "categories#sub_show", as: 'region_category_and_subcategory'
  get 'states/:state_code' => "states#show", as: 'state'
  get 'states/:state_code/category/:category_id' => "states#show_state_and_category", as: 'state_and_category'
  get 'states/:state_code/category/:category_id/subcategory/:sub_category_id' => "states#show_state_category_and_subcategory", as: 'state_category_and_subcategory'

  get 'geocoder_test/test' => 'geocoder_test#test', as: 'geocoder_test'
  get 'geocoder_test/geolocation' => 'geocoder_test#geolocation_api', as: 'geocoder_api'

  root 'pages#home'
  get '/coverage', :to => redirect('coverage/index.html')
end
