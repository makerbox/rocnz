Rails.application.routes.draw do

  get 'warning/exists'

  get 'test/index'

  resources :discounts
  resources :quantities
  resources :orders
  resources :products
  get 'privacy/index'

  get 'terms/index'


  get 'home/test'
  get 'home/pull'
  get 'home/seed'
  get 'home/roc'
  get 'home/locello'
  get 'home/polasports'
  get 'home/unity'
  get 'home/about'
  get 'home/contact'
  get 'home/confirm'

resources :products do
  member do
    get 'hide'
    get 'add'
    get 'remove'
    get 'calc_qty_disc'
  end
end

  resources :accounts do
    member do
      get 'approve'
      get 'unapprove'
      get 'orderas'
      get 'destroy_user'
    end
  end
  
  resources :orders do
    member do
      get 'sendorder'
      get 'cart'
      get 'addto'
      get 'kfime'
    end
  end
  
  devise_for :users, controllers: { registrations: "registrations" }
  
  get 'home/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

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
