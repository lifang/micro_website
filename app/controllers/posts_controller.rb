#encoding:utf-8
class PostsController < ApplicationController
  layout 'sites'
  SITE_PATH = "/public/allsites/%s/"
  def index
    @site=Site.find(params[:site_id])
    @posts=@site.posts
  end

  def new
    @site=Site.find(params[:site_id])

  end

  def create
    @site=Site.find(params[:site_id])
    @post=@site.posts.build
    @post.title=params[:posts][:title]
    @post.post_content=params[:posts][:post_content]
    @tmp = params[:posts][:post_img]
    @full_dir=@full_path=Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/bbs"
    @full_path=Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/bbs/"+@tmp.original_filename
    @post.post_img=@full_path
    @post.post_status=0
    if @post.save
      FileUtils.mkdir_p @full_dir unless File::directory?( @full_dir )
      file=File.new(@full_path,'wb')
      FileUtils.cp @tmp.path,file
      flash[:success]="成功"
      redirect_to site_posts_path(@site)
    else
      flash[:success]="shibai"
      render 'index'
    end
  end
  def destroy
    @post=Post.find(params[:id])
    post_img=@post.post_img
    if @post.destroy
  end
  def edit
  end

  def show
  end
end
