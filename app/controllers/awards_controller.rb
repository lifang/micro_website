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
    @award.name=params[:awards][:begin_date]
    @award.total_number=params[:awards][:total_number]
    @award.no_operation_number=params[:awards][:total_number]
    @award.begin_date=params[:awards][:begin_date]
    @award.end_date=params[:awards][:end_date]

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
    name=params[:awards][:begin_date]
    total_number=params[:awards][:total_number]
    begin_date=params[:awards][:begin_date]
    end_date=params[:awards][:end_date]
    if @award.updates(name:name,total_number:total_number,begin_date:begin_date,end_date:end_date )
      
    else
      
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
end
