class DeliverLaterPost
  @queue = :deliver_late

  def self.perform(article_id)
    @article = Article.find(article_id.to_i)
    AdminMailer.new_post(@article).deliver_later
    SubscriberMailer.new_post(@article).deliver_later
  end
end
