class CommentsController < ApplicationController

  def create
    @article = Article.find_by(slug: params[:article_slug])
    @article.comments.create(comments_params)
    redirect_to article_path(@article.slug)
  end

  def destroy
    @article = Article.find_by( slug: params[:article_slug])
    @article.comments.find(params[:id]).destroy    
    redirect_to article_path(@article.slug)
  end

  def spam
    @article = Article.find_by( slug: params[:article_id])
    @comment = @article.comments.find(params[:id])
    if @comment.spam.to_i == 1 then @comment.spam = 0 else @comment.spam = 1 end
    redirect_to article_path(@article.slug) if @comment.save
  end 

  private
  def comments_params
    params[:comment][:spam] = 0; 
    params.require(:comment).permit(:commenter, :body, :spam)
  end
end
