Rails.application.routes.draw do
  get 'main/dashboard'

  # get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # User
  get 'user/index/:type' => 'user#index', as: :user_index
  post 'user/create' => 'user#create'
  post 'user/login' => 'user#login'
  get 'user/logout' => 'user#logout'
  post 'user/update' => 'user#update_profile'
  post 'user/avatar' => 'user#save_avatar'
  post "user/change_password" => "user#update_password"

  # Main
  get 'main/dashboard' => 'main#dashboard', as: :dashboard
  get 'main/profile' => 'main#profile'
  get "main/all_cards" => "main#all_cards"
  post "main/card/new" => "card#create"
  post "main/card/view" => "card#view"
  get "main/card/detail" => "card#view_card_detail"
  get "main/password" => "main#password", as: :update_password


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
