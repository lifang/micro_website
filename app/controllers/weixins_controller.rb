#encoding: utf-8
class WeixinsController < ApplicationController
  require 'digest/sha1'
  require 'net/http'
  require "uri"
  require 'openssl'
  skip_before_filter :authenticate_user!
  #ZHUJUN_TOKEN = "zhujun"


  def accept_message_from_normal_user
    #if accept_token
    render "echo", :formats => :xml, :layout => false
    #else
    # render :text => "error"
    #end

  end

  def accept_token
    signature, timestamp, nonce, echostr = params[:signature], params[:timestamp], params[:nonce], params[:echostr]
    tmp_arr = [params[:cweb], timestamp, nonce]
    tmp_arr.sort!
    tmp_str = tmp_arr.join
    tmp_encrypted_str = Digest::SHA1.hexdigest(tmp_str)
p "**************************"
    if request.request_method == "POST" && tmp_encrypted_str == signature
      #render "echo", :formats => :xml, :layout => false
    p "=================================="
      create_menu
    elsif request.request_method == "GET" && tmp_encrypted_str == signature
      render :text => tmp_encrypted_str == signature ? echostr :  false
    end

  end
  
  
  def get_access_token
    token_url = "https://api.weixin.qq.com"
    token_action = "/cgi-bin/token?grant_type=client_credential&appid=wxcbc2e8fb02023e4f&secret=1243a493f356a0c9ffcc2b7633a78b61"
    token_info = create_get_http(token_url ,token_action)
    p "------------------------"
    p token_info
    return token_info
  end
  
  def create_menu
  access_token = get_access_token
    if access_token and access_token["access_token"]
      menu_str = {:button => [{
           :name => "课程报名",
           :sub_button => [
           {  
               :type => "view",
               :name => "最新课程",
               :url => "http://116.255.202.113/allsites/wansu"
            },
            {
               :type => "view",
               :name => "优惠课程",
               :url => "http://116.255.202.113/allsites/wansu"
            },
            {
               :type => "view",
               :name => "品牌课程",
               :url => "http://116.255.202.113/allsites/wansu"
            }]
       },
    {:type => "view", :name => "万苏世界", :url => "http://116.255.202.113/allsites/wansu"}]
        }.to_json.gsub!(/\\u([0-9a-z]{4})/) {|s| [$1.to_i(16)].pack("U")}
      
      c_menu_url = "https://api.weixin.qq.com"
      c_menu_action = "/cgi-bin/menu/create?access_token=#{access_token["access_token"]}"
      #params = {:access_token => access_token, :body => menu_str}
      response = create_post_http(c_menu_url ,c_menu_action ,menu_str)
      p "================"
      p response
      render :text => response.to_s, :layout => false
    else
      render :text => false
    end  
  end
  
  def create_get_http(url ,route)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.port==443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request= Net::HTTP::Get.new(route)
    back_res =http.request(request)
    return JSON back_res.body
  end
  
  def create_post_http(url,route_action,params)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.port==443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request = Net::HTTP::Post.new(route_action)
    request.set_body_internal(params)
  p "--------pppp"
  p request.body
    return JSON http.request(request).body
  end
  
end