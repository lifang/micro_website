#encoding:utf-8
module AppManagementsHelper
  def exist_app?
    unless @site.exist_app
      flash[:error] = '您尚未使用app功能！'
      redirect_to site_pages_path(@site)
    end
  end
end
