class ImageTextController < ApplicationController
  before_filter :get_site

  def index
    render "demo", :layout => false
  end
  def img_text
    @site=Site.find(params[:site_id])
    @imgs_path=@site.resources
    render :layouts=>false
  end
  def create_imgtxt
    name=params[:name];
    title=params[:title];
    check=params[:check];
    imgarr=params[:src].split(",");
    textstr=params[:text].split(",");
    p 11111111111111111
    puts imgarr,textstr
    render :text=>1
  end
end