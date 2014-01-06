class KeywordsController < ApplicationController
  before_filter :get_site
  layout 'sites'
  def index
    @keywords = @site.keywords
  end
  def create
    @keyword = Keywords.new
  end

  def destroy

  end

  
end
