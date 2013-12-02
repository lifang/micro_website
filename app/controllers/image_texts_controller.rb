#encoding: utf-8
class ImageTextsController < ApplicationController
  before_filter :get_site
  layout 'sites'

  def index
    @title = "微网站-图文"
    @image_texts = Page.image_text.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    @imgs_path = @site.resources
  end

  def new
    @page = Page.new
  end

  def create
    p 11111111111
    p params
  end
 
end