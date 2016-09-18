Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'region/show'
  resources :region do
    get :autocomplete_region_name, :on => :collection
    resources :categories, only: [:show]
    resources :businesses, only: [:show]
  end
  get 'category/:id' => "categories#list", as: 'businesses_for_category'
  get 'category/:category_id/sub_category/:id' => "categories#sub_list", as: 'businesses_for_category_and_subcategory'
  get '/region/:region_id/category/:category_id/sub_category/:id' => "categories#sub_show", as: 'businesses_for_category_region_and_subcategory'
  get 'states/:state_code' => "states#show", as: 'state'
  get 'states/:state_code/category/:category_id' => "states#show_state_category", as: 'state_category'
  get 'states/:state_code/category/:category_id/subcategory/:sub_category_id' => "states#show_state_category_sub_category", as: 'state_category_sub_category'

  get 'geocoder_test/test' => 'geocoder_test#test', as: 'geocoder_test'
  get 'geocoder_test/geolocation' => 'geocoder_test#geolocation_api', as: 'geocoder_api'

  root 'pages#home'

  devise_for :admins,controllers: {
        registrations: 'registrations/registrations'
      }
  

  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
