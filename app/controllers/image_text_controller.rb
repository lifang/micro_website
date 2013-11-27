class ImageTextController < ApplicationController


  def index
    render "demo", :layout => false
  end
  def img_text
    @site=Site.find(params[:site_id])
    @imgs_path=@site.resources
    render :layouts=>false
  end
end