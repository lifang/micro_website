#encoding:utf-8
class AppManagementsController < ApplicationController
layout 'sites'
 before_filter :get_site
  def index
    @client = Client.where("site_id=? and types = 0" , @site.id)[0]
    @record = Record.find_by_site_id(@site.id)
    @remind = Remind.find_by_site_id(@site.id)
  end


  def create_client_info_model
    @client = Client.where("site_id=? and types = 0" , @site.id)[0]
    form = params[:form]
    if @client && @client.update_attribute(:html_content,params[:html_content])
      chi=ClientHtmlInfo.find_by_client_id(@client.id)
      if chi
        chi.update_attribute(:hash_content,form)
      else
        ClientHtmlInfo.create(client_id:@client.id , hash_content:form)
      end
      flash[:success]="保存成功"
      redirect_to site_app_managements_path(@site)
    else
      render 'index'
    end
  end
    
end
