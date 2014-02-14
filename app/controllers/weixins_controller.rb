#encoding: utf-8
class WeixinsController < ApplicationController
  require 'digest/sha1'
  require 'net/http'
  require "uri"
  require 'openssl'
  require "open-uri"
  require "tempfile"
  skip_before_filter :authenticate_user!
  before_filter :get_site_by_token

  WEIXIN_DOWNLOAD_URL = "http://file.api.weixin.qq.com"
  DOWNLOAD_RESOURCE_ACTION = "/cgi-bin/media/get?access_token=%s&media_id=%s"

  def get_site_by_token
    cweb = params[:cweb]
    if cweb == "wansu" || cweb == "xyyd"
      @site = Site.find_by_cweb("xyyd")
    else
      @site = Site.find_by_cweb(cweb)
    end
    @site
  end
  #用于处理相应服务号的请求以及一开始配置服务器时候的验证，post 或者 get
  def accept_token
    signature, timestamp, nonce, echostr, cweb = params[:signature], params[:timestamp], params[:nonce], params[:echostr], params[:cweb]
    tmp_encrypted_str = get_signature(cweb, timestamp, nonce)
    if request.request_method == "POST" && tmp_encrypted_str == signature
      if params[:xml][:MsgType] == "event" && params[:xml][:Event] == "subscribe"   #用户关注事件
        return_message = get_return_message(cweb, "auto")  #获得关注后回复消息的内容
        define_render(return_message, "auto") #返回渲染方式 :  text/news
        create_menu(cweb)  #创建自定义菜单
      elsif params[:xml][:MsgType] == "text"   #用户发送文字消息
        content = params[:xml][:Content]
        #存储消息并推送到ios端
        get_client_message
        return_message = get_return_message(cweb, "keyword", content)  #获得关键词回复消息
        define_render(return_message, "key") #返回渲染方式 :  text/news
      elsif params[:xml][:MsgType] == "image" #用户发送图片
        save_image_or_voice_from_wx("image")
        render :text => "ok"
      elsif params[:xml][:MsgType] == "voice" #用户发送语音
        save_image_or_voice_from_wx("voice")
        render :text => "ok"
      else
        render :text => "ok"
      end
    elsif request.request_method == "GET" && tmp_encrypted_str == signature  #配置服务器token时是get请求
      render :text => tmp_encrypted_str == signature ? echostr :  false
    end

  end
  #接手用户的任何信息
  def get_client_message(wx_resource_url=nil)
    open_id = params[:xml][:FromUserName]
    if @site
      current_client =  Client.where("site_id=#{@site.id} and types = 0")[0]  #后台登陆人员
      client = Client.find_by_open_id_and_status(open_id, Client::STATUS[:valid])  #查询有效用户
      if @site.exist_app && client && current_client && client.update_attribute(:has_new_message,true)
        Message.transaction do
          begin
            m = Message.find_by_msg_id(params[:xml][:MsgId].to_s)
            if m.nil?
              mess = Message.create!(:site_id => @site.id , :from_user => client.id ,:to_user => current_client.id ,
                :types => Message::TYPES[:record], :content => params[:xml][:Content],
                :status => Message::STATUS[:UNREAD], :msg_id => params[:xml][:MsgId],
                :message_type => 1, :message_path => wx_resource_url)
              if mess
                #推送到IOS端
                APNS.host = 'gateway.sandbox.push.apple.com'
                APNS.pem  = File.join(Rails.root, 'config', 'CMR_Development.pem')
                APNS.port = 2195
                token = current_client.token
                if token
                  badge = Client.where(["site_id=? and types=? and has_new_message=?", @site.id, Client::TYPES[:CONCERNED],
                      Client::HAS_NEW_MESSAGE[:YES]]).length
                  content = "#{client.name}:#{mess.content}"
                  APNS.send_notification(token,:alert => content, :badge => badge, :sound => client.id)
                  recent_client = RecentlyClients.find_by_site_id_and_client_id(@site.id, client.id)
                  if recent_client
                    recent_client.update_attributes!(:content => mess.content)
                  else
                    RecentlyClients.create!(:site_id => @site.id, :client_id => client.id, :content => mess.content)
                  end
                end
              end
            end
          rescue
          end
        end
      end
    end
  end
  

  #创建自定义菜单
  def create_menu(cweb)
    access_token = get_access_token(cweb)
    if access_token and access_token["access_token"]
      menu_str = get_menu_by_website(cweb)
      c_menu_action = "/cgi-bin/menu/create?access_token=#{access_token["access_token"]}"
      response = create_post_http(WEIXIN_OPEN_URL ,c_menu_action ,menu_str)
      # render :text => response.to_s, :layout => false
    else
      #render :text => false
    end
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
                :url => MW_URL + "/sites/static?path_name=/wansu/newCourse.html#mp.weixin.qq.com"
              },
              {
                :type => "view",
                :name => "优惠课程",
                :url => MW_URL + "/sites/static?path_name=/wansu/yhCourse.html#mp.weixin.qq.com"
              },
              {
                :type => "view",
                :name => "品牌课程",
                :url => MW_URL + "/sites/static?path_name=/wansu/brandCourse.html#mp.weixin.qq.com"
              }]
          },
          {:type => "view",
            :name => "万苏世界",
            :url => MW_URL + "/sites/static?path_name=/wansu/index.html"
          }
        ]
      }
    end
    menu_bar = menu_bar.to_json.gsub!(/\\u([0-9a-z]{4})/) {|s| [$1.to_i(16)].pack("U")}
    menu_bar
  end

  def get_site(cweb)
    if cweb == "wansu" || cweb == "xyyd"
      site = Site.find_by_cweb("xyyd")
    else
      site = Site.find_by_cweb(cweb)
    end
    site
  end

  def define_render(return_message, flag)
    if return_message
      micro_message, micro_image_text = return_message
      if micro_message && micro_message.text?
        @message = micro_image_text[0].content if micro_image_text && micro_image_text[0]
        if @site.exist_app && micro_message.solid_link_flag == MicroMessage::SOLID_LINK[:app]
          @message = "&lt;a href='#{MW_URL + @message}?open_id=#{params[:xml][:FromUserName]}' &gt; 请点击登记您的信息&lt;/a&gt;"
        end
        if micro_message.solid_link_flag == MicroMessage::SOLID_LINK[:ggl]
          @message = "&lt;a href='#{MW_URL + @message}&amp;secret_key=#{params[:xml][:FromUserName]}' &gt;点击参与&lt;/a&gt;"
        end
        xml = teplate_xml
        render :xml => xml        #关注 自动回复的文字消息
      else
        @items = micro_image_text || []
        render "news" , :formats => :xml, :layout => false  #关注 自动回复的图文消息
      end
    else
      txml =
        <<Text
<xml>
  <ToUserName><![CDATA[#{params[:xml][:FromUserName]}]]></ToUserName>
  <FromUserName><![CDATA[#{params[:xml][:ToUserName]}]]></FromUserName>
  <CreateTime>#{Time.now.to_i}</CreateTime>
  <MsgType><![CDATA[text]]></MsgType>
  <Content></Content>
  <FuncFlag>0</FuncFlag>
</xml>
Text
      render :xml => txml
    end
  end

  def teplate_xml
 

    template_xml =
      <<Text
<xml>
  <ToUserName><![CDATA[#{params[:xml][:FromUserName]}]]></ToUserName>
  <FromUserName><![CDATA[#{params[:xml][:ToUserName]}]]></FromUserName>
  <CreateTime>#{Time.now.to_i}</CreateTime>
  <MsgType><![CDATA[text]]></MsgType>
  <Content>#{@message}</Content>
  <FuncFlag>0</FuncFlag>
</xml>
Text
    template_xml
  end

  def save_image_or_voice_from_wx(flag)
    #file_extension = flag == "image"? ".jpg" : ".amr"
    access_token = get_access_token(cweb)
    p 222222222222222222222
    p access_token
    if access_token and access_token["access_token"]
      media_id = params[:xml][:MediaId]
      msg_id = params[:xml][:MsgId]
      download_action = DOWNLOAD_RESOURCE_ACTION % [access_token["access_token"], media_id]
      http = set_http(WEIXIN_DOWNLOAD_URL)
      request= Net::HTTP::Get.new(download_action)
      back_res = http.request(request)

      if back_res && !back_res[:errmsg].present?
        if @site
          tmp_file = open(WEIXIN_DOWNLOAD_URL + download_action)
          filename = msg_id + File.extname(tmp_file.original_filename)
          weixin_resource = Rails.root.to_s + SITE_PATH % site.root_path + "/weixin_resource/"
          new_file_name = weixin_resource + filename
          FileUtils.mkdir_p(weixin_resource) unless Dir.exists?(weixin_resource)
          File.open(new_file_name, "wb")  {|f| f.write tmp_file.read }
          p 444444444444
          p File.exist?(new_file_name)
          if File.exist?(new_file_name)
            p 333333333333333
            get_client_message(new_file_name)
          end
        end
      end
    end
  end

end
