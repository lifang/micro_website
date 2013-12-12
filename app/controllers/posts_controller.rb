#encoding:utf-8
class PostsController < ApplicationController
  def index
  end

  def new
    @post=@site.posts.build
  end

  def edit
  end

  def show
  end
end
