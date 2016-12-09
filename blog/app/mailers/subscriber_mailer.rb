class SubscriberMailer < ApplicationMailer
  default from: "deepakky25@gmail.com",
          to: Proc.new { Admin.where(subscriber: 1).pluck(:email) }

  def new_post(article)
    @article = article
    @user = User.find(@article.user_id)
    attachments.inline['image.jpg'] = File.read("/root/Documents/blog/app/assets/article_images/#{@article.picture}")
    subject = "#{@user.name} has published a new article"
    mail(subject: subject )
  end

  def new_comment(article, comment)
    @comment = comment
    @article = article
    subject = "#{@comment.commenter} has commented on  post #{@article.title}"

    mail(subject: subject)
  end
end
