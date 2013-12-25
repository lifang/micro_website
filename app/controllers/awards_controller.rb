#encoding:utf-8
class AwardsController < ApplicationController
  before_filter :get_site
  layout 'sites'
  def index
    @awards=@site.awards
  end

  def new
    @award=@site.awards.build

  end

  def create
    @award=@site.awards.build
    @award.name=params[:award][:name]
    @award.total_number=params[:award][:total_number]
    @award.no_operation_number=params[:award][:total_number]
    @award.begin_date=params[:award][:begin_date]
    @award.end_date=params[:award][:end_date]

    if @award.save
      save_award_item
      flash[:success]='新建成功'
      redirect_to site_awards_path
    else
      flash[:error]='新建失败'
      render 'new'
    end
  end

  def destroy
    @award=Award.find_by_id(params[:id])
    if @award.destroy
      flash[:success]='删除成功'
      redirect_to site_awards_path
    else
      flash[:success]='删除失败'
      render 'index'
    end
  end

  def edit
    @award=Award.find_by_id(params[:id])
  end

  def update
    @award=Award.find_by_id(params[:id])
    name=params[:award][:begin_date]
    total_number=params[:award][:total_number]
    begin_date=params[:award][:begin_date]
    end_date=params[:award][:end_date]
    if @award.update_attributes(name:name,total_number:total_number,begin_date:begin_date,end_date:end_date )
      update_award_item
      flash[:success]='更新成功'
      redirect_to site_awards_path
    else
      flash[:success]='更新失败'
      render 'edit'
    end
  end

  private

  def save_award_item
    name=params[:name]
    content=params[:content]
    number=params[:number]
    (0...name.length).each do|x|
      award_info=@award.award_infos.build
      award_info.name=name[x]
      award_info.content=content[x]
      award_info.number=number[x]
      award_info.save
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
          award_info.update_attributes(name:name[x],content:content[x],number:number[x])
        else
        award_info=@award.award_infos.build
        award_info.name=name[x]
        award_info.content=content[x]
        award_info.number=number[x]
        award_info.save
        end
      end
    end
    if !remove_id.nil?
      remove_id.each do |rid|
        AwardInfo.find_by_id(rid).destroy
      end
    end
  end
end
