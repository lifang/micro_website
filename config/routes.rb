MicroWebsite::Application.routes.draw do
  devise_for :users, :controllers => { :passwords => "passwords" , :registrations => "registrations",:sessions=>'sessions'} do
    get "change", :to => "devise/registrations#edit"
    get "change_password", :to => "devise/passwords#change"
    get "signin", :to => "devise/sessions#new"
    get "signup", :to => "devise/registrations#new"
    get "signout", :to => "devise/sessions#destroy"
  end

  get "user/manage/:type", :to=>"users#index"
  post "user/disable/:uid", :to=>"users#disable"
  post "user/enable/:uid", :to=>"users#enable"
  get "user/delete/:uid", :to=>"users#delete"
  
  post "site/verify/:sid",:to=>"sites#verify"
  post "site/change_status/:sid/:status",:to=>"sites#change_status"
  match "/sites/static", :to => "pages#static"
  match '/destroy_site' ,:to=>'sites#destroy_site' ,via: 'get'
  match "/sites/:site_id/pages/preview", :to => "pages#preview", :as => "preview"
  match "/sites/:site_id/pages/form_preview", :to => "pages#form_preview", :as => "form_preview"
  match "/get_token", :to => "pages#get_token", :as => "get_token"
  match '/check_zip' ,to: 'resources#is_not_repeat' ,via: 'get'
  match '/change_status' ,to: 'sites#change_each_status' ,via: 'get'
  match '/allimg' ,to: 'resources#allimage' ,via: 'get'
  match '/image_text_page',to: 'image_text#create_imgtxt' ,via: 'post'
  # Sample resource route with options:
  resources :sites do
    member do
      post :verify_site
    end
    resources :resources
    resources :pages do
      resources :form_datas
      collection do
        get :sub, :form, :style, :sub_new,  :form_new
        post :preview
      end
      member do
        get :sub_edit,:form_edit, :if_authenticate, :sub_preview
        post :submit_queries
      end
    end

    resources :image_text do
      collection do
         get :img_text
      end
    end
    
  end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
devise_scope :user do
  root to: "devise/sessions#new"
end

  # See how all your routes lay out with "rake routes"


  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
 # match '/:path_name',:to => "pages#static", :path_name => /\w+\/.+\.html/
end

