Rails.application.routes.draw do

  resources :movimientos

  resources :retiros

  resources :causas

  resources :searches

  resources :clients

  devise_for :users
  resources :accounts

  root 'home#index'
  
  get 'search/raw/laboral' => 'searches#raw_laboral', as: 'raw_laboral_search'
  get 'search/raw/civil' => 'searches#raw_civil', as: 'raw_civil_search'
  get 'search/raw/corte' => 'searches#raw_corte', as: 'raw_corte_search'
  post 'search_rut_laboral' =>'searches#search_rut_laboral', defaults: { format: 'js' },as: 'search_rut_laboral'
  post 'search_name_laboral' =>'searches#search_name_laboral', defaults: { format: 'js' },as: 'search_name_laboral'
  post 'search_rut_civil' =>'searches#search_rut_civil', defaults: { format: 'js' },as: 'search_rut_civil'
  post 'search_name_civil' =>'searches#search_name_civil', defaults: { format: 'js' },as: 'search_name_civil'
  post 'search_rut_corte' =>'searches#search_rut_corte', defaults: { format: 'js' },as: 'search_rut_corte'
  post 'search_name_corte' =>'searches#search_name_corte', defaults: { format: 'js' },as: 'search_name_corte'
  
  # Wiselinks example
  get '/wiselink-example-1' => 'home#wiselink_example_1', as: 'wiselink1'
  get '/wiselink-example-2' => 'home#wiselink_example_2', as: 'wiselink2'
  get '/modal_example' => 'home#modal_example', as: 'modal_example'

  get '/theme' => 'home#theme'

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
