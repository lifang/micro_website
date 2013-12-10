#encoding: utf-8
class WeixinsController < ApplicationController
  require 'digest/sha1'
  skip_before_filter :authenticate_user!, :only => [:accept_token, :accept_message_from_normal_user]
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

    if request.request_method == "POST" && tmp_encrypted_str == signature
      render "echo", :formats => :xml, :layout => false
    elsif request.request_method == "GET" && tmp_encrypted_str == signature
      render :text => tmp_encrypted_str == signature ? echostr :  false
    end

  end
end