#encoding: utf-8
class WeixinsController < ApplicationController
  require 'digest/sha1'
  require 'net/http'
  require "uri"
  require 'openssl'
  require 'net/http/post/multipart'
  skip_before_filter :authenticate_user!, :only => [:accept_token, :accept_message_from_normal_user]
  ZHUJUN_TOKEN = "zhujun"


  def accept_message_from_normal_user
    #if accept_token
    render "echo", :formats => :xml, :layout => false
    #else
    # render :text => "error"
    #end

  end

  def accept_token
    signature, timestamp, nonce, echostr = params[:signature], params[:timestamp], params[:nonce], params[:echostr]
    tmp_arr = ["amanda_mfl", timestamp, nonce]
    tmp_arr.sort!
    tmp_str = tmp_arr.join
    tmp_encrypted_str = Digest::SHA1.hexdigest(tmp_str)

    if request.request_method == "POST" && tmp_encrypted_str == signature
      #render "echo", :formats => :xml, :layout => false
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
    if get_access_token and get_access_token["access_token"]
      menu_str = {:button => [
        {:type => "click", :name => "Menu1", :key => "MENU1"},{:type => "click", :name => "Menu2", :key => "MENU2"}
        ]}#.to_json
      access_token = get_access_token["access_token"]
      c_menu_url = "https://api.weixin.qq.com"
      c_menu_action = "/cgi-bin/menu/create?access_token=#{access_token}"
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
    request.set_form_data(params)
    return JSON http.request(request).body
  end
  
end