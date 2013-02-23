class UserMailer < ActionMailer::Base
  default from: "humblesuggestions@kunalashah.com"
 
  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: 'Thanks for trying out Humble Suggestions')
  end
end