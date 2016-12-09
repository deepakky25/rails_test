class DeliverLaterUser
  @queue = :deliver_late

  def self.perform(user_id)
    @user = User.find(user_id.to_i)
    AdminMailer.new_user(@user).deliver_later
  end
end
