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

MicroWebsite::Application.routes.draw do
  devise_for :users do
    get "change", :to => "devise/registrations#edit"
    get "change_password", :to => "devise/passwords#edit"
    get "signin", :to => "devise/sessions#new"
    get "signup", :to => "devise/registrations#new"
    get "signout", :to => "devise/sessions#destroy"
  end

  match "/sites/:site_id/pages/preview", :to => "pages#preview", :as => "preview"
  # Sample resource route with options:
  resources :sites do
    resources :resources
    resources :pages do
      collection do
        get :sub, :form, :style, :sub_new,  :form_new
        post :preview
      end
      member do
        get :sub_edit,:form_edit, :if_authenticate, :sub_preview
      end
    end
  end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'sites#index'

# See how all your routes lay out with "rake routes"

# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id))(.:format)'
end

