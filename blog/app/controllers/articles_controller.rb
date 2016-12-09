require 'action_view'
class ArticlesController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def index
    @articles = Article.all
    @articles.each {|article| article.text = strip_tags(article.text)}
  end
 
  def show
    @article = Article.find_by(slug: params[:slug])
  end
 
  def new
    @article = Article.new
  end
 
  def edit
    @article = Article.find_by(slug: params[:slug])
  end
 
  def create
    image_prep()
    @article.image_upload(params[:article][:image], params[:article][:picture])
    @article = Article.new(params.require(:article).permit(:title, :text, :picture, :user_id, :slug, :imgname))
    if @article.save
      redirect_to article_path(@article.slug), flash: {success: "Post successfully posted."} 
    else 
      render new_article_path, flash: {danger: "Post submission failed!!!"} 
    end
  end
 
  def update
    byebug
    @article = Article.find(params[:slug])
    image_prep()
    @article.image_upload(params[:article][:image], params[:article][:picture]) if params[:article][:picture]
    if @article.update(params.require(:article).permit(:title, :text, :picture, :user_id, :slug, :imgname))
      redirect_to article_path(@article.slug), flash: {success: "Post updated successfully."}
    else
      render edit_article_path(@article.slug), flash: {danger: "Post updation failed!!!"}
    end
  end
 
  def destroy
    @article = Article.find_by(slug: params[:slug])
    @article.destroy
    redirect_to articles_path
  end

  def image_prep
    byebug
    params[:article][:image] = params[:article][:picture]
    image_name = image_name(params[:article][:image] ? params[:article][:image].original_filename : nil)
    params[:article][:imgname] = params[:article][:image] ? params[:article][:image].original_filename : nil 
    params[:article][:picture] = image_name
  end

  def image_name(name)
    byebug
    time = Time.now.to_i
    if name  then name = name.split('.')[0] + '_' + time.to_s + '.' +name.split('.')[1]  else nil end
  end
end
