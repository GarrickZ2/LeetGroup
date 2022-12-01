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
  get 'main/user/:uid/group' => 'user#get_user_groups'

  # Main
  get 'main/dashboard' => 'main#dashboard', as: :dashboard
  get 'main/profile' => 'main#profile'
  get "main/all_cards" => "main#all_cards"
  post "card/new" => "card#create"
  post "card/view" => "card#view"

  get "main/card/detail" => "card#view_card_detail"
  get "main/password" => "main#password", as: :update_password

  # Card
  get 'card/delete' => 'card#delete'
  get 'card/copy' => 'card#copy'
  post 'card/:cid/edit' => 'card#edit'
  post 'main/card/:cid/share' => 'card#share'
  post 'main/card/:cid/check_exist' => 'card#check_card_exist'

  # Group
  get 'group/:gid' => 'main#group', as: :group_info
  post '/group/new' => 'group#create_group'
  get '/group/join/:code' => 'group#join_group'
  get '/group/:gid/invite' => 'group#generate_invite_code'
  get '/group/:gid/remove_user' => 'group#user_remove'
  post '/group/:gid/update_role' => 'group#change_user_role'
  post '/group/:gid/cards' => 'group#view_group_cards'
  get '/group/:gid/card_detail/:cid' => 'group#view_group_card_detail'
  get 'group/:gid/check_permission/:uid/:cid' => 'group#check_permission'
  get 'group/card/delete' => 'group#delete_card'

end
