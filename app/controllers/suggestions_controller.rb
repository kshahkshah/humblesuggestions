class SuggestionsController < ApplicationController

  def create
    @suggestions = Suggestion.get({
      time:       params[:time], 
      location:   params[:loc], 
      longitude:  params[:longitude], 
      latitude:   params[:latitude]
    })
    render :json => @suggestions.to_json
  end

  def index
    @content = current_user.content_suggestions
  end

end