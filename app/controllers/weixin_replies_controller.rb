class WeixinRepliesController < ApplicationController
  before_filter :get_site
  layout "sites"
  def index
    auto_reply = @site.keywords.auto[0] #自动回复
    @auto_micro_message = auto_reply.micro_message if auto_reply
    @auto_micro_imagetexts = @auto_micro_message.micro_imgtexts if @auto_micro_message

    #所有图文消息
    micro_messages = @site.micro_messages.image_text
    @micro_imagetexts = MicroImgtext.where(:micro_message_id => micro_messages.map(&:id)).group_by{|mm| mm.micro_message_id}
    @key_replies = @site.keywords.keyword   #关键詞回复
  end

  def new
    
  end

  def edit
    
  end
end