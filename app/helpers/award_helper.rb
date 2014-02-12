#encoding: utf-8
module AwardHelper
  def get_award_info(award_infos,id)
    award_infos.each do|award_info|
      if award_info.id==id
        return "#{award_info.name}(#{award_info.content})"
      end
    end
    nil
  end

  def reply_content(micro_message)
    if micro_message
      if micro_message.text?
        if micro_message.solid_link_flag == MicroMessage::SOLID_LINK[:ggl]
          "刮刮乐"
        elsif micro_message.solid_link_flag == MicroMessage::SOLID_LINK[:app]
          "app登记"
        else
          "一条文字"
        end
      elsif micro_message.image_text?
        "一条图文"
      end
    end
  end
end
