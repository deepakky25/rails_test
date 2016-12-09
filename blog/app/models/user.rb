require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt

  validates_presence_of :name, :username, :email, :password, :role 
  validates :username, uniqueness: true
  validates_uniqueness_of :username, if: lambda{ |user| user.username_changed?}
  validates :password, length: 8..20
  validates :email, uniqueness: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :role, inclusion: %w(admin editor user)
  validates :subscriber, inclusion: [true, false] 
  
  before_save :encrypt_password

  after_commit :mail_notification, on: :create



  def self.authenticate(username, password, path)
    user = find_by_username(username)
    next_path = Rails.application.routes.url_helpers.new_session_path 
    puts next_path, user
    if user && Password.new(user.password) == password
      next_path =  path == 'http://localhost:3000/log_in' ? Rails.application.routes.url_helpers.articles_path : path
    end
    return user, next_path
  end

  def encrypt_password
    if password.present?
      self.password = Password.create(password)
    end
  end

  def mail_notification
    Resque.enqueue(DeliverLaterUser, id)
  end

  def self.delete_user(user_id)
    Article.destroy_all(user_id: user_id)
    User.destroy(user_id)
  end
end
