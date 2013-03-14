class UserMailer < ActionMailer::Base
  default from: "suggestions@kunalashah.com"
 
  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: 'Thanks for trying out Humble Suggestions')
  end

  def daily_suggestion(user)
    @user = user
    @suggestions = Suggestion.get({user: @user})
    @suggestion = @suggestions.first
    @title = "Here's an idea for tonight..."

    @track = SuggestionTrack.create({
      user_id: @user.id, 
      content_item_id: @suggestion.item_id,
      via: 'email',
      on:  Time.now
    })
    @tracking_pixel = Mixpanel.tracking_pixel('Daily Suggestion Opened', {
      suggestion_track_id: @track.id,
      distinct_id:         @user.id,
    })

    mail(to: @user.email, subject: @title)
  end
end