class UserMailer < ActionMailer::Base
  default from: "humblesuggestions@kunalashah.com"
 
  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: 'Thanks for trying out Humble Suggestions')
  end

  def daily_suggestion(user)
    @user = user
    @suggestions = Suggestion.get({user: user})
    @suggestion = @suggestions.first
    @title = "Here's idea for tonight..."

    mail(to: user.email, subject: @title)
  end
end