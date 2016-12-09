class DeliverLaterComment
  @queue = :deliver_late

  def self.perform(article_id, comment_id)
    @article = Article.find(article_id.to_i)
    @comment = @article.comments.find(comment_id.to_i)
    AdminMailer.new_comment(@article, @comment).deliver_later
    SubscriberMailer.new_comment(@article, @comment).deliver_later
  end
end
