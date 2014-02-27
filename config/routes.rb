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
  match 'obtain_award', :to=>'awards#obtain_award' ,via: 'get'
  post "site/verify/:sid",:to=>"sites#verify"
  post "site/change_status/:sid/:status",:to=>"sites#change_status"
  match "/sites/static", :to => "pages#static"
  match '/destroy_site' ,:to=>'sites#destroy_site' ,via: 'get'
  match "/sites/:site_id/pages/preview", :to => "pages#preview", :as => "preview"
  match "/sites/:site_id/pages/form_preview", :to => "pages#form_preview", :as => "form_preview"
  match "/get_token", :to => "pages#get_token", :as => "get_token", via: 'get'
  match "/get_award_url", :to => "awards#get_award_url", :as => "get_award_url", via: 'get'
  match "/record_award", :to => "awards#record_award", :as => "record_award", via: 'post'
  match "/check_if_watch", :to => "awards#check_if_watch", :as => "check_if_watch", via: 'get'
  match '/check_zip' ,to: 'resources#is_not_repeat' ,via: 'get'
  match '/change_status' ,to: 'sites#change_each_status' ,via: 'get'
  match '/allimg' ,to: 'resources#allimage' ,via: 'get'
  match 'image_text_page' ,to: 'image_streams#create_imgtxt' , via: 'post'
  match 'imgtxt_edit_update' ,to: 'image_streams#edit_update' ,via: 'post'
  match '/delete_post' ,to: 'posts#delete_post' ,via: 'get'
  match '/top' ,to: 'posts#top' ,via: 'get'
  match '/untop' ,to: 'posts#untop' ,via: 'get'
  match '/search_sites' ,to: 'sites#search',via: 'get'
  match '/model_page' ,to: 'pages#model_page',via: 'post'
  match '/sites/:site_id/app_managements/get_form_date' => 'app_managements#get_form_date', :as => :preview_visits, :via => :post
  match '/submit_redirect' => 'app_managements#submit_redirect', :as => :submit_redirect, :via => :get
  match '/get_form_date' => 'client_forms#get_form_date', :as => :preview_visits, :via => :post
  match '/get_qr_image' ,to:"weixins#get_qr_image"
  match '/get_qr_img_by_url' ,to:"weixins#get_qr_img_by_url"
  # Sample resource route with options:
  namespace :api do
    resources :clients do
      collection do
        post :login, :message_detail, :refresh, :del_recent_client, :get_token
        post :edit_client, :set_receive, :set_undisturbed
      end
    end
    resources :messages do
      collection do
        post :make_record, :edit_record, :send_message_to_user
      end
    end
  end

  resources :sites do
    member do
      post :verify_site
    end
    resources :micro_messages 
    resources :micro_imgtexts
    resources :weixin_replies
    resources :app_managements do
      collection do        
        post :create_client_info_model

      end
    end
    resources :qr_codes

    resources :qr_code_awards  do
      get :win_award_info
    end

    resources :awards do
      get :win_award_info
      collection do
        get :template
        post :save_template
      end
      member do
        get :change
      end
    end
    resources :posts do
      collection do
        get :bbs, :see_more

      end
      member do
        get :bbs_detail,:star
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
        get :sub, :form, :style, :sub_new,  :form_new ,:tmlt_sub_new,:change
        post :preview, :save_template3,:tmlt_sub_create,:zdy_sub_create
      end
      member do
        get :sub_edit,:form_edit, :if_authenticate, :sub_preview ,:tmlt_sub_edit
        post :submit_queries,:tmlt_sub_update
      end
    end
    
    resources :forms do
      member do
        get :submit_redirect
      end
    end

    resources :image_streams do
      #对集合进行操作
      collection do
        get :img_stream
      end
      #对单个进行操作
      member do
        get :edit_itpage,:change
      end
    end
    resources :image_texts do
      collection do
        post :preview
      end
      member do
        put :it_preview
        get :change
      end
    end
    resources :reminds do
      collection do
        post :create_records,:message_record
      end
      member do
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
