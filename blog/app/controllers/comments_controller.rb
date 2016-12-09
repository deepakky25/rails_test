class CommentsController < ApplicationController

  def create
    @article = Article.find_by(slug: params[:article_slug])
    @comment = @article.comments.create(comments_params)
    redirect_to article_path(@article.slug)
  end

  def destroy
    @article = Article.find_by( slug: params[:article_slug])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article.slug)
  end

  def edit
    @article = Article.find_by( slug: params[:article_id]) 
    @comment = @article.comments.find(params[:id])
  end
 
  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comments_params)
      redirect_to article_path(@article.slug)
    end
  end

  def spam
    @article = Article.find_by( slug: params[:article_id])
    @comment = @article.comments.find(params[:id])
    spam = 1
    if @comment.spam.to_i == 1 
        spam = 0
    end
    @comment.spam = spam
    if @comment.save
       redirect_to article_path(@article.slug)
    end
  end 

  private
  def comments_params
    params[:comment][:spam] = 0; 
    params.require(:comment).permit(:commenter, :body, :spam)
  end
end
