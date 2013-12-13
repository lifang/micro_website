#encoding:utf-8
class PostsController < ApplicationController
  layout 'sites'
  SITE_PATH = "/public/allsites/%s/"
  before_filter :get_site
  before_filter :change_page, :only => [:see_more, :bbs]

  def index
    # @site=Site.find(params[:site_id])
    @posts=@site.posts
  end

  def new
    #@site=Site.find(params[:site_id])

  end

  def create
    #@site=Site.find(params[:site_id])
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
    @site=Site.find(params[:site_id])
    @post=Post.find(params[:id])
    post_img = @post.post_img
    if @post.destroy

      flash[:success]="删除成功"
      FileUtils.rm post_img
      redirect_to site_posts_path(@site)
    else
      flash[:success]="删除失败"
      render 'index'
    end
  end
  def edit
  end

  def show
  end

  def bbs
    @posts = @posts.order("created_at desc").limit(3).offset(0)
    @post = @top_post ? @top_post : @posts[0]
    @page = 1 #帖子初始第一页
    render "/bbs/posts/index", :layout => 'bbs'
  end

  def see_more
    # page
    page = params[:page].to_i
    @posts = @posts.order("created_at desc").limit(3).offset(page * 3)
    @page = page + 1 #帖子增加页数
    render :partial => "/bbs/posts/post", :layout => false
  end

  def bbs_detail
    @post = Post.find_by_id(params[:id])
    comments = @post.replies.verified
    @comments = comments.order("created_at desc").limit(3).offset(0)
    @page = 1 #帖子初始第一页
    @comments_total = comments.count
    render "/bbs/posts/detail", :layout => 'bbs'
  end

  private
  def change_page
    @top_post = @site.posts.where("post_status = ?", Post::STATUS[:top])[0]
    @posts = @site.posts.where("id != ?", @top_post.try(:id))
    @post_total = @posts.length
  end
end
