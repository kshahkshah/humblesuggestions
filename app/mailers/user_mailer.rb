class UserMailer < ActionMailer::Base
  default from: "humblesuggestions@kunalashah.com"
 
  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: 'Thanks for trying out Humble Suggestions')
  end

  def daily_suggestion(user)
    @user = user
    @suggestions = Suggestion.get({user: @user})
    @suggestion = @suggestions.first
    @title = "Here's an idea for tonight..."

    @track = SuggestionTrack.new({
      user_id: @user.id, 
      content_item_id: @suggestion.item_id,
      via: 'email',
      on:  Time.now
    }).save

    mail(to: @user.email, subject: @title)
  end
end