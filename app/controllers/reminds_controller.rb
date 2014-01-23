#encoding:utf-8
class RemindsController < ApplicationController
  before_filter :get_site
  def create
    site_id = @site.id
    remind_name = params[:remind_name]
    send_time = params[:send_time]
    free_time = params[:free_time]
    dayfor_time = params[:dayfor_time]
    user_select = params[:user_select]
    remind_content = params[:remind_content]
    if send_time.to_i.eql?(Remind::SEND_TIME[:ENTER])
      free_time = Time.now + dayfor_time.to_i.days
    end
    
    Remind.create(:site_id => site_id,:content => remind_content,:reseve_time => free_time,:title => remind_name,:range => user_select.to_i)
    flash[:notice] = "新建成功!"
    redirect_to "/sites/#{site_id}/app_managements"
  end

  def create_records
    site_id = @site.id
    records_title = params[:records_title]
    records_content = params[:records_content]
    Record.create(:site_id => site_id, :title => records_title, :content => records_content)
    flash[:notice] = "新建成功!"
    redirect_to "/sites/#{site_id}/app_managements"
  end
end
