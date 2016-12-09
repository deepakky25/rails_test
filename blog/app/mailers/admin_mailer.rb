class AdminMailer < ApplicationMailer
  default from: "deepakky25@gmail.com",
          to: "deepakky25@gmail.com"

  def new_user(user)
    @user = user
    subject = "New #{@user.role.capitalize} added"
    
    mail(subject: subject)
  end
  
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
