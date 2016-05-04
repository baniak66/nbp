class UpdateMailer < ActionMailer::Base
  default from: "from@example.com"

  def new_exchange_email(user)
    @user = user
    mail(to: @user.email, subject: 'New exchange is available')
  end
end
