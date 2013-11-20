set :user, "deploy"                            #cap deploy的操作用户
set :deploy_to, "/opt/projects/micro_website"     #服务器上项目位置
set :current_path, "#{deploy_to}/current"
set :shared_path, "#{deploy_to}/shared"
role :web, "116.255.202.113"                          # Your HTTP server, Apache/etc
role :app, "116.255.202.113"                          # This may be the same as your `Web` server
role :db,  "116.255.202.113", :primary => true # This is where Rails migrations will run
set :rails_env, 'production'