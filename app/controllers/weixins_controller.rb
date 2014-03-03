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
  def get_qr_image
    @award =Award.find_by_id(params[:id])
    render layout:'qr_code'
  end
  def dispose_award
    @code  = params[:code].to_i
    index = params[:index]
    @award = Award.find_by_id(params[:award_id])
    if index!="0"
      @award_info = @award.award_infos.where("award_index = ?", index)[0]
      if !@award_info.code.blank? && @award_info.code.include?(@code)
        UserAward.create(award_info_id:@award_info.id,open_id:@code,award_id:@award.id)
        @award_info.code.delete(@code)
        @award_info.update_attribute(:code,@award_info.code)
      else
        @award_info = nil
        @code = 0
      end
    else
      @award_info = nil
      @code = 0
    end
    @award.update_attribute(:no_operation_number,(@award.no_operation_number-1))
    @site = Site.find_by_id(@award.site_id)
    @qr_code = Page.where("site_id = #{@site.id} and template = #{Page::TEMPLATE[:qr_code]}")[0]
    render "/qr_codes/after_scan"
  end
  def get_qr_img_by_url
    # format =  :png
    # size   =  3
    # level  =  :h
    # qrcode = RQRCode::QRCode.new(url, :size => size, :level => level)
    # svg    = RQRCode::Renderers::SVG::render(qrcode, {})
    # image = MiniMagick::Image.read(svg) { |i| i.format "svg" }
    # image.format "png" if format == :png
    # path=image.path
    @award = Award.find_by_id(params[:id])
    current_time = Time.now.strftime("%Y-%m-%d")
    url=""
    if @award
      if current_time >= @award.begin_date.to_s && current_time <= @award.end_date.to_s
        award_infos = @award.award_infos
        total_num = @award.total_number #总的奖券数
        has_award_num = award_infos.sum(:number) #有奖的奖券总数
        no_award_num = total_num - has_award_num  #无奖的奖券总数
        no_operation_number = @award.no_operation_number  #剩余的奖券
        scratched_award_infos, scratched_has_award_infos,scratched_no_award_infos = get_scratched_award(@award)
        scratched_has_award_infos_hash = scratched_has_award_infos.group_by{|ua| ua.award_info_id} #刮过的，有奖的奖券,奖券id分类
       
        #所有索引放进一个string
        award_str = ""
        award_infos.each do |ai|
          award_info_id = ai.id
          if scratched_has_award_infos_hash[award_info_id].present?
            left_number = ai.number - scratched_has_award_infos_hash[award_info_id].length #剩余的未刮过的有奖奖券
          else
            left_number = ai.number
          end
          no_award_num = no_operation_number - left_number #剩余的无奖奖券
          award_str << (ai.award_index.to_s) * left_number if left_number > 0
        end
        left_no_scratched_no_award_num = no_award_num - scratched_no_award_infos.length  #剩余的未刮过的无奖奖券
        award_str << "0" * left_no_scratched_no_award_num  if left_no_scratched_no_award_num> 0 #无奖项默认0
        award_arr = award_str.split("")  #string 转换成数组
        if award_arr.present?
          #乱序数组两次，随机索引数
          award_index = award_arr.shuffle.shuffle[rand(no_operation_number)]  #抽取出来的奖项索引
          # award_index = 1
          if award_index == "0"
            @status = 0  #未中奖
            url = "http://192.168.135.128:3000/dispose_award?code=#{100000 + Random.rand(90000)}&index=0&award_id=#{@award.id}"  #谢谢参与
          else
            @status = 1  #中奖
            @award_info = @award.award_infos.where("award_index = ?", award_index.to_i)[0]
            url ="http://192.168.135.128:3000/dispose_award?code=#{@award_info.code[0].to_s}&index=#{award_index}&award_id=#{@award.id}" if @award_info
          end
        else
          url = "it's none#{rand(1000)}"  #奖券已抽完
        end
      else
        url = "time out#{rand(1000)}"  #奖券未开始或者已经过期
      end 
    end
    respond_to do |format|
      format.html
      format.svg  { render :qrcode => url, :level => :l, :unit => 1 }
      format.png  { render :qrcode => url }
      format.gif  { render :qrcode => url }
      format.jpeg { render :qrcode => url, :level => :l }
    end
  end
  
  def get_scratched_award(award)
    tmp_arr = []
    scratched_award_infos = UserAward.where("award_id = ?", @award.id) #刮过的，所有的奖券
    scratched_has_award_infos = UserAward.where("award_id = ? and award_info_id is not null", @award.id) #刮过的，有奖的奖券
    scratched_no_award_infos = scratched_award_infos - scratched_has_award_infos  #刮过的，无奖的奖券
    tmp_arr << scratched_award_infos << scratched_has_award_infos << scratched_no_award_infos
    tmp_arr
  end

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
        save_image_or_voice_from_wx(cweb, "image")
        render :text => "ok"
      elsif params[:xml][:MsgType] == "voice" #用户发送语音
        save_image_or_voice_from_wx(cweb, "voice")
        render :text => "ok"
      else
        render :text => "ok"
      end
    elsif request.request_method == "GET" && tmp_encrypted_str == signature  #配置服务器token时是get请求
      render :text => tmp_encrypted_str == signature ? echostr :  false
    end
  end
  #接收用户的任何信息
  def get_client_message(wx_resource_url=nil)
    open_id = params[:xml][:FromUserName]
    if @site
      current_client =  Client.where("site_id=#{@site.id} and types = #{Client::TYPES[:ADMIN]}")[0]  #后台登陆人员
      client = Client.find_by_open_id_and_status(open_id, Client::STATUS[:valid])  #查询有效用户
      if @site.exist_app && client && current_client && client.update_attribute(:has_new_message,true)
        time_now = Time.now.strftime("%H:%M")

        Message.transaction do
          begin
            m = Message.find_by_msg_id(params[:xml][:MsgId].to_s)
            if m.nil?
              msg_type_value = Message::MSG_TYPE[params[:xml][:MsgType].to_sym]
              content = params[:xml][:Content]
              unless params[:xml][:Content].present?
                content = msg_type_value == 1 ? "图片" : "语音"
              end
              mess = Message.create!(:site_id => @site.id , :from_user => client.id ,:to_user => current_client.id ,
                :types => Message::TYPES[:weixin], :content => content,
                :status => Message::STATUS[:UNREAD], :msg_id => params[:xml][:MsgId],
                :message_type => msg_type_value, :message_path => wx_resource_url)
              if mess && (!@site.receive_status || !(@site.receive_status && @site.not_receive_start_at && @site.not_receive_end_at && time_now >= @site.not_receive_start_at.strftime("%H:%M") && time_now <= @site.not_receive_end_at.strftime("%H:%M")))
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

  def save_image_or_voice_from_wx(cweb, flag)
    msg_id = params[:xml][:MsgId]
    open_id = params[:xml][:FromUserName]
    client = Client.find_by_open_id_and_status(open_id, Client::STATUS[:valid])  #查询有效用户
    if client && @site
      if flag == "image"
        file_extension = ".jpg"
        remote_resource_url = params[:xml][:PicUrl]

        save_file(remote_resource_url, file_extension, msg_id)
      else
        access_token = get_access_token(cweb)
        if access_token and access_token["access_token"]
          media_id = params[:xml][:MediaId]
          download_action = DOWNLOAD_RESOURCE_ACTION % [access_token["access_token"], media_id]
          remote_resource_url = (WEIXIN_DOWNLOAD_URL + download_action)
          file_extension = ".amr"
          
          http = set_http(WEIXIN_DOWNLOAD_URL)
          request= Net::HTTP::Get.new(download_action)
          back_res = http.request(request)

          if back_res && !back_res[:errmsg].present?
            save_file(remote_resource_url, file_extension, msg_id)
          end
        end
      end
    end
  end

  def save_file(remote_resource_url, file_extension, msg_id)
    tmp_file = open(remote_resource_url) #打开直接下载链接
    filename = msg_id + file_extension  #临时文件不能取到扩展名
    weixin_resource = SITE_PATH % @site.root_path + "weixin_resource/"
    wx_full_resource = Rails.root.to_s + weixin_resource
    new_file_name = wx_full_resource + filename
    FileUtils.mkdir_p(wx_full_resource) unless Dir.exists?(wx_full_resource)
    File.open(new_file_name, "wb")  {|f| f.write tmp_file.read }
    if File.exist?(new_file_name)
      message_path = "/allsites/%s/" % @site.root_path + "weixin_resource/" + filename #保存进数据库的路径
      get_client_message(message_path)
    end
  end
  
end
