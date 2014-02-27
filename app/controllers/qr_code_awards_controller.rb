#encoding:utf-8
class QrCodeAwardsController < ApplicationController
  before_filter :get_site
  layout 'sites'
  def index
    @awards=Award.where(["site_id= ? and types = 1 ",@site.id] )
  end
  def new
    @award=@site.awards.build

  end
  def edit
    @award=Award.find_by_id(params[:id])
  end
  def destroy
    @award=Award.find_by_id(params[:id])
    if @award.destroy
      flash[:success]='删除成功'
      redirect_to site_qr_code_awards_path
    else
      flash[:success]='删除失败'
      render 'index'
    end
  end
  def create
    @award=@site.awards.build
    @award.name=params[:award][:name]
    @award.total_number=params[:award][:total_number]
    @award.no_operation_number=params[:award][:total_number]
    @award.begin_date=params[:award][:begin_date]
    @award.end_date=params[:award][:end_date]
    @award.types = Award::TYPES[:qr_code]
    if @award.save
      save_award_item
      flash[:success]='新建成功'
      redirect_to site_qr_code_awards_path
    else
      flash[:error]='新建失败'
      render 'new'
    end
  end
  def update
    @award=Award.find_by_id(params[:id])
    name=params[:award][:name]
    total_number=params[:award][:total_number]
    begin_date=params[:award][:begin_date]
    end_date=params[:award][:end_date]
    if @award.update_attributes(name:name,total_number:total_number,begin_date:begin_date,end_date:end_date )
      update_award_item
      flash[:success]='更新成功'
      redirect_to site_qr_code_awards_path
    else
      flash[:success]='更新失败'
      render 'edit'
    end
  end
  def save_award_item
    name=params[:name]
    content=params[:content]
    number=params[:number]
    (0...name.length).each do|x|
      award_info=@award.award_infos.build
      award_info.name=name[x]
      award_info.content=content[x]
      award_info.number=number[x]
      award_info.award_index = x + 1 #设置奖项索引,预留0作为无奖项
      if award_info.save
        #生成奖项图片  开始
        img_path = award_info.generate_image(@site.name)
        award_info.img = img_path if img_path
        #生成奖项图片  结束
        award_info.save
      end

    end
  end
  def update_award_item
    remove_id=params[:remove_id]
    id=params[:info_id]
    name=params[:name]
    content=params[:content]
    number=params[:number]
    if !name.nil?
      (0...name.length).each do|x|
        if !id[x].nil?
          award_info=AwardInfo.find_by_id(id[x])
          old_name = award_info.name
          award_info.update_attributes(name:name[x],content:content[x],number:number[x],award_index:x + 1)
          if award_info.name != old_name
            #生成奖项图片  开始
            img_path = award_info.generate_image(@site.name)
            award_info.update_attribute(:img,img_path) if img_path
            #生成奖项图片  结束
          end

        else
          award_info=@award.award_infos.build
          award_info.name=name[x]
          award_info.content=content[x]
          award_info.number=number[x]
          award_info.award_index = x + 1  #设置奖项索引
          if award_info.save
            #生成奖项图片  开始
            img_path = award_info.generate_image(@site.name)
            award_info.img = img_path if img_path
            #生成奖项图片  结束
            award_info.save
          end

        end
      end
    end
    if !remove_id.nil?
      remove_id.each do |rid|
        AwardInfo.find_by_id(rid).destroy
      end
    end
  end

  def win_award_info
    @award=Award.find_by_id(params[:qr_code_award_id])
    @award_infos =AwardInfo.where("award_id = #{params[:qr_code_award_id]}")
    award_info_id=[]
    @award_infos.each do |f|
      award_info_id<<f.id
    end
    @userinfos =UserAward.where( "award_info_id in ( #{award_info_id.join(',')} )")
    @awards_is = @userinfos.group_by{|a| a[:award_info_id]} unless @award_infos.nil?
  end
 #领奖
  def obtain_award
    @user_award=UserAward.find_by_id(params[:id])
    if @user_award && @user_award.update_attribute(:if_checked,true)
      flash[:success]='领取成功'

      redirect_to site_qr_code_awards_path(@site)
    else
      flash[:success]='领取失败'
      render 'index'
    end
  end


end
