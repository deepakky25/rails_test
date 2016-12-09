class Comment < ActiveRecord::Base
  after_commit :handel_mail, on: :create

  belongs_to :article

  def handel_mail
    Resque.enqueue(DeliverLaterComment, self.article.id, self.id)
  end
end
