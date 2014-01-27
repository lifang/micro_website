#encoding: utf-8
class WeixinsController < ApplicationController
  require 'digest/sha1'
  require 'net/http'
  require "uri"
  require 'openssl'
  skip_before_filter :authenticate_user!
  before_filter :get_site_by_token
  def get_site_by_token
    @site = Site.find_by_cweb(params[:cweb])
  end
  #用于处理相应服务号的请求以及一开始配置服务器时候的验证，post 或者 get
  def accept_token
    signature, timestamp, nonce, echostr, cweb = params[:signature], params[:timestamp], params[:nonce], params[:echostr], params[:cweb]
    tmp_encrypted_str = get_signature(cweb, timestamp, nonce)
    if request.request_method == "POST" && tmp_encrypted_str == signature
      if params[:xml][:MsgType] == "event" && params[:xml][:Event] == "subscribe"   #用户关注后收到的回复      
        return_message = get_return_message(cweb, "auto")  #获得关注后回复消息的内容
        define_render(return_message) #返回渲染方式 :  text/news
        create_menu(cweb)  #创建自定义菜单
      elsif params[:xml][:MsgType] == "text"   #用户主动发消息后收到的回复
        content = params[:xml][:Content]
        #存储消息并推送到ios端
        get_client_message
        return_message = get_return_message(cweb, "keyword", content)  #获得关键词回复消息
        if params[:xml][:Content] == "参与"
          open_id = params[:xml][:FromUserName]
          link = get_valid_award(cweb)
          @link = link ? link + "&amp;secret_key=" + open_id : "0"
          if @link == "0"
            @message = "暂无活动"
          else
            @message = "&lt;a href='#{@link}'&gt;点击参与&lt;/a&gt;"
          end
          xml = teplate_xml
          render :xml => xml
        else
          define_render(return_message) #返回渲染方式 :  text/news
        end
      else
        render :text => "ok"
      end
    elsif request.request_method == "GET" && tmp_encrypted_str == signature  #配置服务器token时是get请求
      render :text => tmp_encrypted_str == signature ? echostr :  false
    end

  end
  #接手用户的任何信息
  def get_client_message
    Message.transaction do
      open_id = params[:xml][:FromUserName]
      if @site
        current_client =  Client.where("site_id=#{@site.id} and types = 0")[0]  #后台登陆人员
        client = Client.find_by_open_id(open_id)
        if @site.exist_app && client && current_client && client.update_attribute(:has_new_message,true)
          m = Message.where({:site_id => @site.id , :from_user => client.id ,:to_user => current_client.id, :content => params[:xml][:Content]}).order("created_at asc").last
          time_now = Time.now
          if m.nil? || (m && ((time_now - m.created_at).to_i > 30))
            mess = Message.new(:site_id => @site.id , :from_user => client.id ,:to_user => current_client.id ,
              :types => Message::TYPES[:record], :content => params[:xml][:Content], :status => Message::STATUS[:UNREAD])
            mess.save
            #推送到IOS端
            APNS.host = 'gateway.sandbox.push.apple.com'
            APNS.pem  = File.join(Rails.root, 'config', 'CMR_Development.pem')
            APNS.port = 2195
            token = current_client.token
            if token
              badge = Client.where(["site_id=? and types=? and has_new_message=?", @site.id, Client::TYPES[:CONCERNED],
                  Client::HAS_NEW_MESSAGE[:YES]]).length
              APNS.send_notification(token,:alert => mess.content, :badge => badge, :sound => 'default')
            end
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

  def get_valid_award(cweb)
    if cweb == "wansu" || cweb == "xyyd"
      site = Site.find_by_cweb("xyyd")
    else
      site = Site.find_by_cweb(cweb)
    end
    current_time = Time.now.strftime("%Y-%m-%d")
    award = site.awards.where("begin_date <= ? and end_date >= ?", current_time, current_time).first if site
    return award ? MW_URL + "/sites/static?path_name=/#{site.root_path}/ggl.html" : false
  end

  def define_render(return_message)
    if return_message
      micro_message, micro_image_text = return_message
      if micro_message && micro_message.text?
        @message = micro_image_text[0].content if micro_image_text && micro_image_text[0]
        xml = teplate_xml
        render :xml => xml        #关注 自动回复的文字消息
      else
        @items = micro_image_text || []
        render "news" , :formats => :xml, :layout => false  #关注 自动回复的图文消息
      end
    else
      render :text => "ok"
    end
  end

  def teplate_xml
    a_msg =""
    if @site.exist_app
      a_msg = "&lt;a href='#{MW_URL}allsites/#{@site.root_path}/this_site_app.html?open_id=#{params[:xml][:FromUserName]}' &gt; 请点击 登记您的信息&lt;/a&gt;
      "
    end

    template_xml = <<Text
<xml>
  <ToUserName><![CDATA[#{params[:xml][:FromUserName]}]]></ToUserName>
  <FromUserName><![CDATA[#{params[:xml][:ToUserName]}]]></FromUserName>
  <CreateTime>#{Time.now.to_i}</CreateTime>
  <MsgType><![CDATA[text]]></MsgType>
  <Content>#{a_msg}#{@message}</Content>
  <FuncFlag>0</FuncFlag>
</xml>
Text
    template_xml
  end

end
