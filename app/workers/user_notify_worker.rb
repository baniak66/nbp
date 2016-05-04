class UserNotifyWorker
  include Sidekiq::Worker

  def perform
    users = User.all
    users.each do |user|
      UpdateMailer.new_exchange_email(user).deliver_now
    end
  end
end
