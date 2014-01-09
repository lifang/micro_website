#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  prepend_before_filter :check_user_status
  include ApplicationHelper
  SITE_PATH = "/public/allsites/%s/"
  PUBLIC_PATH =  Rails.root.to_s + "/public/allsites"

  #微信基本url信息
  WEIXIN_OPEN_URL = "https://api.weixin.qq.com"
  APP_ID_AND_SECRET = {:wansu => {:app_id => "wxcbc2e8fb02023e4f", :app_secret => "1243a493f356a0c9ffcc2b7633a78b61"},
    :senvern => {:app_id => "wx4179ca59f560599b", :app_secret => "e5080f5963ead815439875eb0fdc66d7"}
  }
  MW_URL = "http://web.sunworldmedia.com/"
  
  require "fileutils"
  require 'net/http'
  require "uri"
  require 'openssl'

  def get_site
    @site = Site.find_by_id params[:site_id]
    if @site && @site.user != current_user
      render(:file  => "#{Rails.root}/public/404.html",
        :layout => nil,
        :status   => "404 Not Found")
    end
  end

  def redirect_path(page, site)
    if page.main?
      site_pages_path(site)
    elsif page.sub?
      sub_site_pages_path(site)
    elsif page.form?
      form_site_pages_path(site)
    elsif page.image_text?
      site_image_texts_path(site)
    end
  end

  def save_into_file(content, page, old_file_name)
    site_root = page.site.root_path if page.site
    site_path = Rails.root.to_s + SITE_PATH % site_root
    FileUtils.mkdir_p(site_path) unless Dir.exists?(site_path)
    if old_file_name.present? && old_file_name != page.file_name
      File.delete site_path + old_file_name if File.exists?(site_path + old_file_name)
    end
    File.open(site_path + page.file_name, "wb") do |f|
      f.write(content.html_safe)
    end
    page.path_name = "/" + site_root + "/" + page.file_name
    page.save
  end

  def after_sign_in_path_for(resource)
    resource.admin ? "/user/manage/1" : '/sites'
  end

  def check_user_status
    if current_user && current_user.status != User::STATUS_NAME[:normal]
      sign_out current_user
    end
  end

  def check_admin
    if current_user && !current_user.admin
      sign_out current_user
    end
  end


  #根据app_id 和app_secret获取帐号token
  def get_access_token(cweb)
    app_id = get_app_id(cweb)
    app_secret = get_app_secret(cweb)
    token_action = "/cgi-bin/token?grant_type=client_credential&appid=#{app_id}&secret=#{app_secret}"
    token_info = create_get_http(WEIXIN_OPEN_URL ,token_action)
    return token_info
  end

  def get_app_id(cweb)
    (cweb == "wansu" || cweb == "xyyd") ? APP_ID_AND_SECRET[:wansu][:app_id] : APP_ID_AND_SECRET[cweb.to_sym] && APP_ID_AND_SECRET[cweb.to_sym][:app_id]
  end

  def get_app_secret(cweb)
    (cweb == "wansu" || cweb == "xyyd") ? APP_ID_AND_SECRET[:wansu][:app_secret] : APP_ID_AND_SECRET[cweb.to_sym] && APP_ID_AND_SECRET[cweb.to_sym][:app_secret]
  end

  #发get请求获得access_token
  def create_get_http(url ,route)
    http = set_http(url)
    request= Net::HTTP::Get.new(route)
    back_res = http.request(request)
    return JSON back_res.body
  end
  
  #发post请求创建自定义菜单
  def create_post_http(url,route_action,menu_bar)
    http = set_http(url)
    request = Net::HTTP::Post.new(route_action)
    request.set_body_internal(menu_bar)
    return JSON http.request(request).body
  end

  #设置http基本参数
  def set_http(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.port==443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    http
  end

  #根据微信 cweb，获取自动回复的消息
  def get_return_message(cweb, flag, content=nil)
    site = Site.find_by_cweb(cweb)
    if flag == "auto"
      message = Keyword.find_by_site_id_and_types(site.id, Keyword::TYPE[:auto]) #查询是否有自动回复
    else
      message = Keyword.find_by_site_id_and_types_and_keyword(site.id, Keyword::TYPE[:keyword], content) #查询是否有关键词对应回复
    end
    if message
      micro_message = message.micro_message  #获取对应的消息记录
      micro_it = micro_message.micro_imgtexts if micro_message
      return [micro_message, micro_it]
    else
     return false
    end
  end

  
end
