#encoding:utf-8
class QrCodeAwardsController < ApplicationController
  before_filter :get_site
  layout 'sites'
  SITE_PATH = "/public/allsites/%s/"
  def index
    @awards=Award.where(["site_id= ? and types = 1 ",@site.id] )
  end
  def new
    @award=nil
  end
  def edit
    @award=Award.find_by_id(params[:id])
  end
  def destroy
    @award =Award.find_by_id(params[:id])
    award_infos = AwardInfo.where(["award_id = ?",@award.id])
    award_infos.each do |award_info|
     
      remove_old_image Rails.root.to_s+"/public"+ award_info.content
    end
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
    name =params[:name]
    @tmp =params[:content]
    number=params[:number]
    (0...name.length).each do|x|
      time_str = Time.now.usec
      save_qr_code_img @tmp[x],time_str
      award_info=@award.award_infos.build
      award_info.name=name[x]
      award_info.content="/allsites/#{@site.root_path}/qr_code_imgs/#{time_str}"+@tmp[x].original_filename
      award_info.number=number[x]
      award_info.award_index = x + 1 #设置奖项索引,预留0作为无奖项
      if award_info.save
        award_info.code =create_code award_info
        award_info.save
      end
    end
  end
  #生成奖项code
  def create_code award_info
    arr=[]
    award_info.number.times do |t|
      arr << Time.now.usec
    end
     arr
  end

  def update_award_item
    remove_id=params[:remove_id]
    id=params[:info_id]
    name=params[:name]
    content=""
    @tmp = params[:content]
    number=params[:number]
    if !name.nil?
      (0...name.length).each do|x|
        time_str = Time.now.usec
        if @tmp &&@tmp[x] && !@tmp[x].nil?
          save_qr_code_img @tmp[x],time_str
        end
        if !id[x].nil?
          award_info =AwardInfo.find_by_id(id[x])
          if @tmp &&@tmp[x] && !@tmp[x].nil?
            remove_old_image Rails.root.to_s+"/public/"+award_info.content
          end
          old_name = award_info.name
          if @tmp&&@tmp[x]&&!@tmp[x].nil?
          award_info.update_attributes(
            name:name[x],
            content:"/allsites/#{@site.root_path}/qr_code_imgs/#{time_str}"+@tmp[x].original_filename,
            number:number[x],award_index:x + 1 ,
            code:(create_code award_info) )
          else
          award_info.update_attributes(
            name:name[x],
            number:number[x],award_index:x + 1 ,
            code:(create_code award_info) )
          end

        else
          award_info=@award.award_infos.build
          award_info.name=name[x]
          award_info.content="/allsites/#{@site.root_path}/qr_code_imgs/#{time_str}"+@tmp[x].original_filename
          award_info.number=number[x]
          award_info.award_index = x + 1  #设置奖项索引
          if award_info.save
            award_info.code =create_code award_info
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

  def remove_old_image img_path
    FileUtils.rm img_path if File.exist?(img_path)
    FileUtils.rm (get_min_by_imgpath img_path) if File.exist?(get_min_by_imgpath img_path)
  end

  def save_qr_code_img tmp,time_str
    dir_path = Rails.root.to_s+SITE_PATH%@site.root_path+"qr_code_imgs"
    path  = dir_path+"/#{time_str}"+ tmp.original_filename
    FileUtils.mkdir_p  dir_path unless Dir.exists?(dir_path)
    file1 =File.new(path,'wb')
    FileUtils.cp tmp.path,file1
    min_image(path,tmp.original_filename,dir_path,"50x50","_min.",time_str)
  end

  def min_image(ful_path,filename,ful_dir,size,end_name,time_str)
    target_path =ful_dir+"/#{time_str}"+filename.split(".")[0...-1].join(".")+end_name+filename.split(".")[-1]
    if !File.exist?(target_path)
      image = MiniMagick::Image.open(ful_path)
      image.resize size
      image.write  target_path
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
    phone = params[:phone]
    @user_award=UserAward.find_by_id(params[:id])
    if @user_award && @user_award.update_attributes(:if_checked=>true,secret_code:phone)
      flash[:success]='领取成功'
      redirect_to site_qr_code_awards_path(@site)
    else
      flash[:success]='领取失败'
      render 'index'
    end
  end


end
