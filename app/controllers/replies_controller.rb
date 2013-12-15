class RepliesController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :get_site
  before_filter :get_post

  def create
    @comment = @post.replies.create(params[:comment])
    if @comment.save
      @path = bbs_detail_site_post_path(@site, @post)
      render "/bbs/comments/success"
    else
      render "/bbs/comments/fail"
    end
  end
  
  def see_more
    #page
    page = params[:page].to_i
    comments = @post.replies.verified
    @comments_total = comments.count
    @comments = comments.order("created_at desc").limit(3).offset(page * 3)
    
    @comments_count = @comments_total - page * 3
    @page = page + 1 #帖子翻页
    render :partial => "/bbs/comments/comment", :layout => false
  end

  private
  def get_post
    @post = Post.find_by_id(params[:post_id])
  end
end