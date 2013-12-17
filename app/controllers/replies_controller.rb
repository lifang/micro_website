#encoding:utf-8
class RepliesController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :get_site
  before_filter :get_post

  def create
    reply_total = @post.replies.length
    params[:comment][:send_open_id] = reply_total + 1
    @comment = @post.replies.create(params[:comment])
    
    if @comment.save
      #@path = bbs_detail_site_post_path(@site, @post)
      
      comments = @post.replies
      @comments = comments.order("created_at desc").limit(3).offset(0)
      @page = 1 #帖子初始第一页
      @comments_total = @comments_count = comments.length
      render "/bbs/comments/success"
    else
      render "/bbs/comments/fail"
    end
  end
  
  def see_more
    #page
    page = params[:page].to_i
    comments = @post.replies
    @comments_total = comments.count
    @comments = comments.order("created_at desc").limit(3).offset(page * 3)
    @comments_count = @comments_total - page * 3
    @page = page + 1 #帖子翻页
    render :partial => "/bbs/comments/comment", :layout => false
  end
  def destroy
    @post =Post.find(params[:post_id])
    @reply=Reply.find(params[:id])
    if @reply.update_attribute(:status,3)
      @post.update_attribute(:praise_number,@post.praise_number-1)
      flash[:success]="删除成功"
      redirect_to site_post_path(@site,@post)
    else
      flash[:success]="删除失败"
      render 'posts/show'
    end
  end
  def verify
    @post =Post.find(params[:post_id])
    @reply=Reply.find(params[:id])
  end
  def verifyt
    change_verify 1
  end
  def verifyf
    change_verify 2
  end
  def reply_comment_new
    
    render "/bbs/comments/reply_comment"
  end
  def reply_comment_create
    
  end

  private
  def change_verify(flag)
     @site =Site.find(params[:site_id])
     @post =Post.find(params[:post_id])
     @reply =Reply.find(params[:id])
     p 1111111111111111111111111222222225454646545421,@reply,flag
     if @reply.update_attribute(:status,flag)
        flash[:success]='审核成功'
        redirect_to site_post_path(@site,@post)
     else
        flash[:error]='审核失败'
        redirect_to site_post_path(@site,@post)
     end
  end
  def get_post
    @post = Post.find_by_id(params[:post_id])
  end
  
  def get_site
    @site = Site.find_by_id params[:site_id]
  end
end