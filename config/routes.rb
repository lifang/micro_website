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
  match 'image_text_page' ,to: 'image_streams#create_imgtxt' , via: 'post'
  match 'imgtxt_edit_update' ,to: 'image_streams#edit_update' ,via: 'post'
  match '/delete_post' ,to: 'posts#delete_post' ,via: 'get'
  match '/top' ,to: 'posts#top' ,via: 'get'
  match '/untop' ,to: 'posts#untop' ,via: 'get'
  # Sample resource route with options:
  resources :sites do
    member do
      post :verify_site
    end
    resources :posts do
      collection do
        get :bbs, :see_more
      end
      member do
        get :bbs_detail
        post :star
      end
      resources :replies do
        collection do
          get :see_more
        end
        member do
          get :verifyt,:verifyf,:verify
        end
      end
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

    resources :image_streams do
      #对集合进行操作
      collection do
        get :img_stream
      end
      #对单个进行操作
      member do
        get :edit_itpage
      end
    end
    resources :image_texts do
      collection do
        post :preview
      end
      member do
        put :it_preview
      end
    end
  end
  match "/weixins/accept_token" => "weixins#accept_token"

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
