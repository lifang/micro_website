#encoding: utf-8
class UsersController  < ApplicationController
   # before_action :set_user ,only: [:disable,:delete]
  layout 'sites'
  def index
    # puts 'index..................................................................'
    # puts params
    
     case params[:type]
     when '1' then @type=1; @users=User.paginate(:page=>params[:page],:per_page=>10,:conditions =>"status!=-1")
     when '2' then @type=2; @sites=Site.paginate(:page=>params[:page],:per_page=>10,:conditions => "status=2") #待审核
     when '3' then @type=3; @sites=Site.paginate(:page=>params[:page],:per_page=>10,:conditions => "status=3")  #审核通过 
     when '4' then @type=4; @sites=Site.paginate(:page=>params[:page],:per_page=>10,:conditions => "status=4") #审核不通过
     end 
 
     render 'index'
  end
  
  
  
  def disable
    # puts 'disable.....................................'  
    set_user
      puts params
     if @user.update_attribute(:status,0)      #用户状态              1:正常           0：禁用       -1：删除   
       # flash[:msg]='success!'      
     else      
       # flash[:msg]='error!'    
     end
     
     render 'users/change_status'
    # respond_to do |format|     
       # format.html{redirect_to "/user/manage/1?page=#{set_page}"}  
       # format.js   
    # end   
  end
  
  
  
  
  
  
  def enable  
    # puts 'enable.....................................................................' 
    set_user
     
     if @user.update_attribute(:status,1)       
       # flash[:msg]='success!'      
     else      
       # flash[:msg]='error!'    
     end
     
     render 'users/change_status'
    # respond_to do |format|     
      # format.html{redirect_to "/user/manage/1?page=#{set_page}"}    
       # format.js     
    # end 
    
  end
  
  
  
  
  def delete
    # puts 'delete........................................'
    set_user
    if @user.update_attribute(:status,-1)
      # flash[:msg]='success!'
    else
      # flash[:msg]='error!'     
    end  
    respond_to do |format|    
      
       page=params[:page]
        
       if(page==''||page==1)  
        format.html{redirect_to "/user/manage/1"}
       else
        format.html{redirect_to "/user/manage/1?page=#{page}"}
       end
       
    end   
  end
  
  
  
  def set_user  
     @user=User.find(params[:uid])
  end
  
  
  

  
end