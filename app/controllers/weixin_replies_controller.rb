class WeixinRepliesController < ApplicationController
  before_filter :get_site
  layout "sites"
  def index
    #自动回复
    auto_reply = @site.keywords.auto[0]
    @auto_micro_message = auto_reply.micro_message if auto_reply
    @auto_micro_imagetexts = @auto_micro_message.micro_imgtexts if @auto_micro_message

    #关键詞回复
    @key_replies = @site.keywords.includes(:micro_message).keyword
    key_micro_messages = MicroMessage.where(:id => @key_replies.map(&:micro_message_id))
    @key_micro_imagetexts = MicroImgtext.where(:micro_message_id => key_micro_messages.map(&:id)).group_by{|mm| mm.micro_message_id}

    #所有图文消息
    micro_messages = @site.micro_messages.image_text
    @micro_imagetexts = MicroImgtext.where(:micro_message_id => micro_messages.map(&:id)).group_by{|mm| mm.micro_message_id}
    
  end

  def new
    
  end

  def edit
    
  end

  def create
    micro_message_id, text, flag, keyword = params[:micro_message_id], params[:text], params[:flag], params[:keyword] #图文消息，文字消息， 自动回复(auto)/关键字回复(keyword)
    Keyword.transaction do
      if text.present? #文字回复
        micro_message = @site.micro_messages.create(:mtype => MicroMessage::TYPE[:text])
        micro_message_id = micro_message.id if micro_message
        micro_imagetext = micro_message.micro_imgtexts.create(:content => text ) if micro_message
      end
      if flag == 'auto'  #自动回复
        auto_message = @site.keywords.auto[0]
        if auto_message.present?
          reply = auto_message.update_attribute(:micro_message_id, micro_message_id)
        else
          reply = @site.keywords.create(:micro_message_id => micro_message_id, :types => Keyword::TYPE[:auto])
        end
      else #关键字回复
        reply = @site.keywords.create(:micro_message_id => micro_message_id, :keyword => keyword, :types => Keyword::TYPE[:keyword])
      end
      render :text => reply ? "success" : "error"
    end
  end

  def update
    micro_message_id, text, flag, keyword = params[:micro_message_id], params[:text], params[:flag], params[:keyword] #图文消息，文字消息， 自动回复(auto)/关键字回复(keyword)
    Keyword.transaction do
      keyword = Keyword.find_by_id params[:id]
      if text.present? #文字回复
        micro_message = @site.micro_messages.create(:mtype => MicroMessage::TYPE[:text])
        micro_message_id = micro_message.id if micro_message
        micro_imagetext = micro_message.micro_imgtexts.create(:content => text ) if micro_message
      end
      reply = keyword.update_attributes({:micro_message_id => micro_message_id, :keyword => keyword})
      render :text => reply ? "success" : "error"
    end
  end
end