class KeywordsController < ApplicationController
  before_filter :get_site
  layout 'sites'
  def index
    @keywords = @site.keywords
  end
end
