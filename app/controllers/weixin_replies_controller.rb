#encoding: utf-8
class WeixinRepliesController < ApplicationController
  before_filter :get_site
  layout "sites"
  def index
    #自动回复
    @auto_reply = @site.keywords.auto[0]
    @auto_micro_message = @auto_reply.micro_message if @auto_reply
    @auto_micro_imagetexts = @auto_micro_message.micro_imgtexts if @auto_micro_message

    #关键詞回复
    @key_replies = @site.keywords.includes(:micro_message).keyword.paginate(:per_page => 2, :page => params[:page])
    key_micro_messages = MicroMessage.where(:id => @key_replies.map(&:micro_message_id))
    @key_micro_imagetexts = MicroImgtext.where(:micro_message_id => key_micro_messages.map(&:id)).group_by{|mm| mm.micro_message_id}

    #所有图文消息
    micro_messages = @site.micro_messages.image_text
    @micro_imagetexts = MicroImgtext.where(:micro_message_id => micro_messages.map(&:id)).group_by{|mm| mm.micro_message_id}
  end

  def destroy
    keyword = Keyword.find_by_id params[:id]
    micro_message = keyword.micro_message
    if micro_message.text?
      micro_message.destroy
    end
    keyword.destroy
    flash[:notice] = "删除成功"
    redirect_to site_weixin_replies_path(@site)
  end

  def create
    micro_message_id, text, flag, keyword = params[:micro_message_id], params[:text], params[:flag], params[:keyword] #图文消息，文字消息， 自动回复(auto)/关键字回复(keyword)
    begin
      Keyword.transaction do
        if text.present? #文字回复
          micro_message = @site.micro_messages.create(:mtype => MicroMessage::TYPE[:text])
          micro_message_id = micro_message.id if micro_message
          micro_message.micro_imgtexts.create(:content => text ) if micro_message
        end
        if flag == 'auto'  #自动回复
          auto_message = @site.keywords.auto[0]
          if auto_message.present?
            auto_message.update_attribute(:micro_message_id, micro_message_id)
          else
            @site.keywords.create(:micro_message_id => micro_message_id, :types => Keyword::TYPE[:auto])
          end
        else #关键字回复
          @site.keywords.create(:micro_message_id => micro_message_id, :keyword => keyword, :types => Keyword::TYPE[:keyword])
        end
        
      end
      flash[:notice] = "保存成功"
      render :success
    rescue
      render :failed
    end
  end

  def update  #关键字更新
    micro_message_id, text, flag, keyword_param,@index = params[:micro_message_id], params[:text], params[:flag], params[:keyword], params[:index].to_i #图文消息，文字消息， 自动回复(auto)/关键字回复(keyword)
    begin
      Keyword.transaction do
        @keyword = Keyword.find_by_id params[:id]
        micro_message = @keyword.micro_message
        #关键詞回复
        if text.present? #文字回复
          if micro_message.text? #原来就是文字回复，更新
            micro_message.micro_imgtexts[0].update_attribute(:content, text) if micro_message.micro_imgtexts[0]
            @keyword.update_attributes({:keyword => keyword_param})
          else  #原来是图文回复，新建文字回复
            micro_message = @site.micro_messages.create(:mtype => MicroMessage::TYPE[:text])
            micro_message.micro_imgtexts.create(:content => text ) if micro_message
            @keyword.update_attributes({:micro_message_id => micro_message.id, :keyword => keyword_param})
          end
        else #图文回复
          if micro_message.text?  #原来是文字，删除原来消息
            micro_message.destroy
          end
          #根据传过来的图文id更新关键字
          @keyword.update_attributes({:micro_message_id => micro_message_id, :keyword => keyword_param})
        end
        key_micro_message = @keyword.micro_message
        @key_micro_imagetexts = MicroImgtext.where(:micro_message_id => key_micro_message).group_by{|mm| mm.micro_message_id}
      end
      flash[:notice] = "保存成功"
      render :update
    rescue
      render :failed
    end
  end
end