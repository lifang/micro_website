class PageSweeper < ActionController::Caching::Sweeper

  observe Page

  def after_update(page)
    p 111111111111111111111111111111111
    expire_page :controller => "pages", :action => "static"
  end
#
#  def after_destroy(pege)
#    expire_staff_page
#  end
#
#  def expire_staff_page
#    $stderr.puts "@@@@@ Expiring staff page"
#    expire_page( :controller => 'welcome', :action => 'staff' )
#    $stderr.puts "@@@@@ Staff Page Expired"
#  end
end