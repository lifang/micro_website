module AwardHelper
  def get_award_info(award_infos,id)
    award_infos.each do|award_info|
      if award_info.id==id
        return "#{award_info.name}(#{award_info.content})"
      end
    end
    nil
  end
end
