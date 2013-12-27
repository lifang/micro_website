#encoding:utf-8
class AwardsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:show, :record_award, :get_award_url]
  before_filter :get_site, :except => [:show, :record_award, :get_award_url]
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
    name=params[:award][:name]
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

  def show
    @award = Award.find_by_id(params[:id])
    @open_id = params[:secret_key]
    current_time = Time.now.strftime("%Y-%m-%d")
    if @award
      if current_time >= @award.begin_date.to_s && current_time <= @award.end_date.to_s
        award_infos = @award.award_infos
        user_award = UserAward.where(:open_id => @open_id, :award_info_id => award_infos.map(&:id))[0] #用户是否刮过
        if !user_award
          total_num = @award.total_number #总的奖券数
          no_operation_number = @award.no_operation_number  #剩余的奖券
          has_award_num = award_infos.sum(:number) #有奖的奖券总数
          #TODO
          #减去user_awards里面的记录
        

          no_award_num = no_operation_number - has_award_num  #无奖的奖券总数
          #所有索引放进一个string
          award_str = ""
          award_infos.each do |ai|
            award_str << (ai.award_index.to_s) * ai.number
          end
          award_str << "0" * no_award_num  #无奖项默认0
          award_arr = award_str.split("")  #string 转换程数组

          #乱序数组三次，随机索引数
          award_index = award_arr.shuffle.shuffle.shuffle[rand(total_num)]  #抽取出来的奖项索引
        
          if award_index == "0"
            @status = 0  #未中奖
            @img = "/assets/thanks.png"  #谢谢参与
          else
            @status = 1  #中奖
            @award_info = @award.award_infos.where("award_index = ?", award_index.to_i)[0]
            @img = @award_info.img if @award_info
          end
        else
          award_info = user_award.award_info
          @status = 2  #已经抽过奖
        end
      else
        @status = 3  #奖券未开始或者已经过期
        @img = false 
      end
      render :layout => false
    else
      render(:file  => "#{Rails.root}/public/404.html",
        :layout => nil,
        :status   => "404 Not Found")
    end
    
  end
  def win_award_info
    @award=Award.find_by_id(params[:award_id])
    @award_infos =AwardInfo.where("award_id = #{params[:award_id]}")
    award_info_id=[]
    @award_infos.each do |f|
      award_info_id<<f.id
    end
    p 11111111111111,award_info_id
    @userinfos =UserAward.where( "award_info_id in ( #{award_info_id.join(',')} )")
    @awards_is = @userinfos.group_by{|a| a[:award_info_id]} unless @award_infos.nil?
    p 22226546542222,@awards_is
  end

  def record_award
    begin
      UserAward.transaction do
        UserAward.create(:open_id => params[:opent_id], :award_info_id => params[:award_info_id])
        award = Award.find_by_id(params[:award_id])
        award.update_attribute(:no_operation_number, award.no_operation_number - 1) if award
      end
      render :text => "success"
    rescue
      render :text => "error"
    end
  end

  def get_award_url
    site_root_path = params[:site_root_path]
    site = Site.find_by_root_path(site_root_path)
    current_time = Time.now.strftime("%Y-%m-%d")
    award = site.awards.where("begin_date <= ? and end_date >= ?", current_time, current_time).first if site
    render :text => award ? site_award_url(site, award) : "none"
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
end
