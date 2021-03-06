Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :retiros
    end
  end

  get 'user_causa/update'

  resources :movimientos

  resources :retiros

  resources :general_causas
  resources :user_causa, only: [:update]

  resources :searches

  resources :clients

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :accounts


  root 'home#index'

  get '/search_add_causa' => 'accounts#search'
  get '/cortes' => 'general_causas#cortes', as: 'cortes'

  get '/admin/search_records' => 'admins#search_records', as:'admin_records'
  get '/admin/clients' => 'admins#clients', as:'admin_clients'
  get '/admin/users' => 'admins#users', as:'admin_users'

  get '/accounts/:id/causas' => 'accounts#causas', as: 'lawyer_causas'
  get '/accounts/:id/clients' => 'accounts#clients', as: 'lawyer_clients'

  get 'changes' => "general_causas#changes", as: 'changes'


  get 'search/raw/laboral' => 'searches#raw_laboral', as: 'raw_laboral_search'
  get 'search/raw/civil' => 'searches#raw_civil', as: 'raw_civil_search'
  get 'search/raw/corte' => 'searches#raw_corte', as: 'raw_corte_search'
  get 'search/raw/procesal' => 'searches#raw_procesal', as: 'raw_procesal_search'
  get 'search/raw/suprema' => 'searches#raw_suprema', as: 'raw_suprema_search'
  post 'search_rut_laboral' =>'searches#search_rut_laboral', defaults: { format: 'js' },as: 'search_rut_laboral'
  post 'search_name_laboral' =>'searches#search_name_laboral', defaults: { format: 'js' },as: 'search_name_laboral'
  post 'search_rut_civil' =>'searches#search_rut_civil', defaults: { format: 'js' },as: 'search_rut_civil'
  post 'search_name_civil' =>'searches#search_name_civil', defaults: { format: 'js' },as: 'search_name_civil'
  post 'search_rut_corte' =>'searches#search_rut_corte', defaults: { format: 'js' },as: 'search_rut_corte'
  post 'search_name_corte' =>'searches#search_name_corte', defaults: { format: 'js' },as: 'search_name_corte'
  post 'search_rut_procesal' =>'searches#search_rut_procesal', defaults: { format: 'js' },as: 'search_rut_procesal'
  post 'search_name_procesal' =>'searches#search_name_procesal', defaults: { format: 'js' },as: 'search_name_procesal'
  post 'search_rut_suprema' =>'searches#search_rut_suprema', defaults: { format: 'js' },as: 'search_rut_suprema'
  post 'search_name_suprema' =>'searches#search_name_suprema', defaults: { format: 'js' },as: 'search_name_suprema'

  post 'accounts/add_causa' => 'accounts#add_causa', as: 'add_causa'
  post 'accounts/remove_causa' => 'accounts#remove_causa', as: 'remove_causa'
  post 'accounts/add_client' => 'accounts#add_client', as: 'add_client'
  get 'search_clients' => 'accounts#search_clients', as: 'search_clients'


  get 'search' => 'searches#search', as: 'search_causa'
  
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
