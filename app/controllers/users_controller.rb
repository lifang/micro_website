#encoding: utf-8
class UsersController  < ApplicationController
   # before_action :set_user ,only: [:disable,:delete]
  layout 'sites'
  def index
    # puts 'index..................................................................'
    # puts params
    
     case params[:type]
     when '1' then @type=1; @users=User.paginate(:page=>params[:page],:per_page=>10,:conditions =>"status!=-1 and types!=1")#不是删除用户，不是管理员
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
        change_site_tatus(@user,4) #将用户对应站点status设置为审核不通过
       
       # flash[:msg]='已禁用该用户!'      
     else      
        #flash[:msg]='禁用失败!'    
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
       
        change_site_tatus(@user,1) #将用户对应站点status设置为未审核
     
       # flash[:msg]='已启用改用户!'      
     else      
       # flash[:msg]='启用失败!'    
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
       change_site_tatus(@user,4) #将用户对应站点status设置为审核不通过
      
      
      # flash[:msg]='删除成功!'
    else
      # flash[:msg]='删除失败!'     
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
  
  
  
  
  def change_site_tatus user, s   #修改指定站点的status
               
      Site.where("user_id=#{user.id}").update_all(status: s)          
  end

  
end