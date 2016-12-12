class Comment < ActiveRecord::Base
  belongs_to :article

  validates_presence_of :commenter, :body, :spam 
  validates :commenter, length: { minimum: 3 }
  validates :body, length: { minimum: 6 }
  validates :spam, inclusion: [1, 0]

  after_commit :mail_notification, on: :create

  def mail_notification
    Resque.enqueue(DeliverLaterComment, self.article_id, self.id)
  end
end
