#encoding:utf-8
class PostsController < ApplicationController
  layout 'sites'
  SITE_PATH = "/public/allsites/%s/"
  before_filter :get_site
  before_filter :change_page, :only => [:see_more, :bbs]
  skip_before_filter :authenticate_user!, :only => [:bbs, :see_more, :bbs_detail, :star]
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
    if @top_post
      @post = @top_post
      @post_total = @tmp_posts.length
      @posts = @tmp_posts.limit(3).offset(0)
    else
      @post = @tmp_posts[0]
      @posts = @posts = @tmp_posts.where("id not in (#{@post.id})").limit(3).offset(0) if @post
      @post_total = @tmp_posts.length - 1
    end
    
    #@post = @top_post ? @top_post : @posts[0]
    @page = 1 #帖子初始第一页
    render "/bbs/posts/index", :layout => 'bbs'
  end

  def see_more
    # page
    page = params[:page].to_i
    if @top_post
      @post = @top_post
      @post_total = @tmp_posts.length
      @posts = @tmp_posts.limit(3).offset(page * 3)
    else
      @post = @tmp_posts[0]
      @posts = @tmp_posts.where("id not in (#{@post.id})").limit(3).offset(page * 3)
      @post_total = @tmp_posts.length - 1
    end
    @page = page + 1 #帖子增加页数
    render :partial => "/bbs/posts/post", :layout => false
  end

  def bbs_detail
    @post = Post.find_by_id(params[:id])
    comments = @post.replies
    @comments = comments.order("created_at desc").limit(3).offset(0)
    @page = 1 #帖子初始第一页
    @comments_total = @comments_count = comments.length
    render "/bbs/posts/detail", :layout => 'bbs'
  end

  def star
    @post = Post.find_by_id(params[:id])
    if @post
      if params[:flag] == "1"
        @post.update_attribute(:praise_number, @post.praise_number + 1)
      else
        @post.update_attribute(:praise_number, @post.praise_number - 1)
      end
      msg = "success"
    else
      msg = "error"
    end
    render :text => msg
  end

  private
  def change_page
    @top_post = @site.posts.where("post_status = ?", Post::STATUS[:top])[0]
    @tmp_posts = @top_post ?  @site.posts.where("id != ?", @top_post.try(:id)).order("created_at desc") : @site.posts.order("created_at desc")
    
  end

  def get_site
    @site = Site.find_by_id params[:site_id]
  end
end
