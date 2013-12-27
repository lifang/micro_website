#encoding: utf-8
class WeixinsController < ApplicationController
  require 'digest/sha1'
  require 'net/http'
  require "uri"
  require 'openssl'
  skip_before_filter :authenticate_user!
  WEIXIN_OPEN_URL = "https://api.weixin.qq.com"
  APP_ID_AND_SECRET = {:wansu => {:app_id => "wxcbc2e8fb02023e4f", :app_secret => "1243a493f356a0c9ffcc2b7633a78b61"}}

  #用于处理相应服务号的请求以及一开始配置服务器时候的验证，post 或者 get
  def accept_token
    signature, timestamp, nonce, echostr, cweb = params[:signature], params[:timestamp], params[:nonce], params[:echostr], params[:cweb]
    tmp_encrypted_str = get_signature(cweb, timestamp, nonce)
    p params[:xml][:MsgType]
    p params[:xml][:Content]
    if request.request_method == "POST" && tmp_encrypted_str == signature
      if params[:xml][:MsgType] == "event" && params[:xml][:Event] == "subscribe"
        create_menu(cweb)
      elsif params[:xml][:MsgType] == "text" && params[:xml][:Content] == "参与"
        open_id = params[:xml][:FromUserName]
        link = get_valid_award(cweb)
        p 11111111111111
        p link + "?secret_key=" + open_id
        @link = link ? link + "&secret_key=" + open_id : "暂无活动"
        render "echo", :formats => :xml, :layout => false        #回复信息
      else
        render :text => "success"
      end

    elsif request.request_method == "GET" && tmp_encrypted_str == signature  #配置服务器token时是get请求
      render :text => tmp_encrypted_str == signature ? echostr :  false
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

  #创建自定义菜单
  def create_menu(cweb)
    access_token = get_access_token(cweb)
    if access_token and access_token["access_token"]
      menu_str = get_menu_by_website(cweb)
      c_menu_action = "/cgi-bin/menu/create?access_token=#{access_token["access_token"]}"
      response = create_post_http(WEIXIN_OPEN_URL ,c_menu_action ,menu_str)
      render :text => response.to_s, :layout => false
    else
      render :text => false
    end
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

  #验证请求是否从微信发出
  def get_signature(cweb, timestamp, nonce)
    tmp_arr = [cweb, timestamp, nonce]
    tmp_arr.sort!
    tmp_str = tmp_arr.join
    tmp_encrypted_str = Digest::SHA1.hexdigest(tmp_str)
    tmp_encrypted_str
  end

  #根据cweb，获得不同的自定义菜单
  def get_menu_by_website(cweb)

    if cweb == "wansu" || cweb == "xyyd"
      menu_bar = {:button => [{
            :name => "课程报名",
            :sub_button => [
              {
                :type => "view",
                :name => "最新课程",
                :url => "http://116.255.202.113/sites/static?path_name=/wansu/newCourse.html#mp.weixin.qq.com"
              },
              {
                :type => "view",
                :name => "优惠课程",
                :url => "http://116.255.202.113/sites/static?path_name=/wansu/yhCourse.html#mp.weixin.qq.com"
              },
              {
                :type => "view",
                :name => "品牌课程",
                :url => "http://116.255.202.113/sites/static?path_name=/wansu/brandCourse.html#mp.weixin.qq.com"
              }]
          },
          {:type => "view",
            :name => "万苏世界",
            :url => "http://116.255.202.113/sites/static?path_name=/wansu/index.html"
          }
        ]
      }
    end
    menu_bar = menu_bar.to_json.gsub!(/\\u([0-9a-z]{4})/) {|s| [$1.to_i(16)].pack("U")}
    menu_bar
  end

  def get_app_id(cweb)
    (cweb == "wansu" || cweb == "xyyd") ? APP_ID_AND_SECRET[:wansu][:app_id] : APP_ID_AND_SECRET[cweb.to_sym][:app_id]
  end

  def get_app_secret(cweb)
    (cweb == "wansu" || cweb == "xyyd") ? APP_ID_AND_SECRET[:wansu][:app_secret] : APP_ID_AND_SECRET[cweb.to_sym][:app_secret]
  end

  def set_http(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.port==443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    http
  end

  def get_valid_award(cweb)
    if cweb == "wansu" || cweb == "xyyd"
      site = Site.find_by_cweb("xyyd")
      current_time = Time.now.strftime("%Y-%m-%d")
      award = site.awards.where("begin_date <= ? and end_date >= ?", current_time, current_time).first if site
    end
    return award ? request.host + "/sites/static?path_name=/#{site.root_path}/刮刮乐.html" : false
  end
  
end