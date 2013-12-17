#encoding:utf-8
class PostsController < ApplicationController
  layout 'sites'
  SITE_PATH = "/public/allsites/%s/"
  before_filter :get_site
  before_filter :change_page, :only => [:see_more, :bbs]
  skip_before_filter :authenticate_user!, :only => [:bbs, :see_more, :bbs_detail, :star]
  def index
    # @site=Site.find(params[:site_id])
    @posts=@site.posts.order("created_at desc").paginate(page:params[:page],:per_page => 9)
  end

  def new
    #@site=Site.find(params[:site_id])

  end
  def edit
    @post=Post.find(params[:id])
  end
  def create
    #@site=Site.find(params[:site_id])
    @time=(Time.now.to_f * 1000000).to_i
    @post=@site.posts.build
    @post.title=params[:posts][:title]
    @post.post_content=params[:posts][:post_content]
    @tmp = params[:posts][:post_img]
    @post.praise_number=0;
    @full_dir=@full_path=Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/bbs"
    @full_path=Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/bbs/#{@time}"+@tmp.original_filename
    @post.post_img="/allsites/"+ @site.root_path+"/bbs/#{@time}"+@tmp.original_filename
    #是否置顶
    @post.post_status=params[:posts][:post_status]
    if @post.save
      FileUtils.mkdir_p @full_dir unless File::directory?( @full_dir )
      file=File.new(@full_path,'wb')
      FileUtils.cp @tmp.path,file
      flash[:success]="创建成功"
      redirect_to site_posts_path(@site)
    else
      flash[:success]="创建失败"
      render 'index'
    end
  end
  
  def destroy
    #@site=Site.find(params[:site_id])
    @post=Post.find(params[:id])
    post_img = @post.post_img
    if @post.destroy
      flash[:success]="删除成功"
      FileUtils.rm Rails.root.to_s+"/public"+post_img
      redirect_to site_posts_path(@site)
    else
      flash[:success]="删除失败"
      render 'index'
    end
  end
  
  def delete_post
    destroy
  end
  
  def update
    @post=Post.find(params[:id])
    title=params[:posts][:title]
    post_content=params[:posts][:post_content]
    temp=@post_img
    post_img = @post.post_img
    @tmp = params[:posts][:post_img]
    if !@tmp.nil?
      @full_dir=@full_path=Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/bbs"
      @full_path=Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/bbs/"+@tmp.original_filename
      post_img="/allsites/"+ @site.root_path+"/bbs/"+@tmp.original_filename
    end
    if @post.update_attributes(title:title,post_content:post_content,post_img:post_img)
      if !@tmp.nil?
        file=File.new(@full_path,'wb')
        FileUtils.rm (Rails.root.to_s+"/public"+temp) unless temp.nil?
        FileUtils.cp @tmp.path,file
      end
      flash[:success]="编辑成功"
      redirect_to site_posts_path(@site)
    else
      flash[:success]="编辑失败"
      render 'index'
    end

  end
  
  def top
    @p=Post.where('post_status = 1')
    if @p 
      @p[0].update_attribute(:post_status,0)
    end
    change_top 1
  end
  
  def untop
    change_top 0
  end
  def edit
    @post=Post.find(params[:id])
  end

  def change_top(flag)
    @site =Site.find(params[:site_id])
    @post =Post.find(params[:id])
    if @post.update_attribute(:post_status,flag)
      flash[:success]='置顶成功'
      redirect_to site_posts_path(@site)
    else
      flash[:error]='置顶失败'
      render 'index'
    end
  end
  def show
    @site =Site.find(params[:site_id])
    @post =Post.find(params[:id])
    @replies = @post.replies
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
