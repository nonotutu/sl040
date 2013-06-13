Sl040::Application.routes.draw do
  

  resources :purchases

  resources :sections


  match 'equipment'       => 'equipment#index',      :as => :equipment
  match 'staff'           => 'staff#index',          :as => :staff
  match 'accounting'      => 'accounting#index',     :as => :accounting
  match 'google_drive'    => 'home#google_drive',    :as => :google_drive # TODO: change
  match 'accounting/accdoc_from_scratch'          => 'accounting#accdoc_from_scratch',          as: :accdoc_from_scratch
  match 'accounting/generate_accdoc_from_scratch' => 'accounting#generate_accdoc_from_scratch', as: :generate_accdoc_from_scratch
  match 'accounting/bdc_from_scratch'          => 'accounting#bdc_from_scratch',          as: :bdc_from_scratch
  match 'accounting/generate_bdc_from_scratch' => 'accounting#generate_bdc_from_scratch', as: :generate_bdc_from_scratch
  
  match 'google_drive/dump'      => 'google_drive#dump',   :as => :google_drive_dump
  match 'google_drive/import'    => 'google_drive#import', :as => :google_drive_import
  match 'write_to_google_drive'  => 'google_drive#write',  :as => :google_drive_write
  match 'read_from_google_drive' => 'google_drive#read',   :as => :google_drive_read
  
  devise_for :users

  match 'table_items_containers'  => 'equipment#table_items_containers',   :as => :table_items_containers
  match 'table_volunteers_trainings'  => 'staff#table_volunteers_trainings', :as => :table_volunteers_trainings
  
  root :to => 'home#index'
  match 'error' => 'home#error', :as => :error

  match 'tests_css' => 'home#tests_css'
  
  match 'activities/index_metro' => 'activities#index_metro', :as => :activities_metro
  match 'activities/:id/show_metro' => 'activities#show_metro', :as => :activity_metro

  match 'staff/volunteers/index_metro'    => 'volunteers#index_metro', :as => :volunteers_metro
  match 'staff/volunteers/:id/show_metro' => 'volunteers#show_metro',  :as => :volunteer_metro
  
#   match 'volunteers/:volunteer_id/certificates/manage_all' => 'certificates#manage_all', :as => :manage_all_certificates
#   match 'certificates#create_from_manage_all_certificates', :as => :create_from_manage_all_certificates
  
  match 'staff/volunteers_to_google_drive' => 'staff#volunteers_to_google_drive', as: :volunteers_to_google_drive
  
  match 'activities/:id/confirmer_presence' => 'registrations#confirmer_presence', as: :confirmer_presence
  
#   match 'activities/:activity_id/registrations/:id/status' => 'registrations#status', as: :activity_registration_status
  
  resources :activities do
    resources :registrations
    resources :act_needs
  end
  resources :departments
  resources :users
  
  scope "/staff" do
    resources :trainings
    resources :volunteers do
      resources :certificates
    end
  end
  
  scope "/equipment" do
    resources :categories
    resources :containers do
      resources :contents
    end
    resources :items
    resources :suppliers
  end

  match '*path' => 'home#routing_error'

  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
