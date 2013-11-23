#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :check_user_status
  include ApplicationHelper
  SITE_PATH = "/public/allsites/%s/"
  require "fileutils"

  def get_site
    @site = Site.find_by_id params[:site_id]
  end

  def save_into_file(content, page)
    site_root = page.site.root_path if page.site
    site_path = Rails.root.to_s + SITE_PATH % site_root
    FileUtils.mkdir_p(site_path) unless Dir.exists?(site_path)
    File.open(site_path + page.file_name, "wb") do |f|
      f.write(content.html_safe)
    end
    page.path_name = "/" + site_root + "/" + page.file_name
    page.save
  end

  def after_sign_in_path_for(resource)
    resource.admin ? "/user/manage/1" : root_path
  end

  def check_user_status
    if current_user && current_user.status != User::STATUS_NAME[:normal]
      sign_out current_user
    end
  end
end
