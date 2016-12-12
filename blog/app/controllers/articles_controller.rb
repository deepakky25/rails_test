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
    1.times do
      image = @article.images.build
  end
  end
 
  def edit
    @article = Article.find_by(slug: params[:slug])
  end
 
  def create
    image_prep()
    @article = Article.new(params.require(:article).permit(:title, :text, :user_id, :slug, images_attributes: [:id, :filename]))
    if @article.save
      @article.image_upload(params[:article][:image])
      redirect_to article_path(@article.slug), flash: {success: "Post successfully posted."} 
    else 
      render new_article_path, flash: {danger: "Post submission failed!!!"} 
    end
  end
 
  def update
    @article = Article.find(params[:slug])
    image_prep()
    if @article.update(params.require(:article).permit(:title, :text, :user_id, :slug, images_attributes: [:id, :filename]))
      @article.image_upload(params[:article][:image])
      redirect_to article_path(@article.slug), flash: {success: "Post updated successfully."}
    else
      render edit_article_path(@article.slug), flash: {danger: "Post updation failed!!!"}
    end
  end
 
  def destroy
    @article = Article.find_by(slug: params[:slug])
    @article.comments.each {|comment| comment.destroy}
    @article.destroy
    redirect_to articles_path
  end

  def image_prep
    params[:article][:image] = params[:article][:images_attributes]["0"][:filename]
    params[:article][:images_attributes]["0"][:filename] = params[:article][:image] ? params[:article][:image].original_filename : nil
  end
end
