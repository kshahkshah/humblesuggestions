class SuggestionsController < ApplicationController

  def create
    @suggestions = Suggestion.get({
      time:       params[:time], 
      location:   params[:loc], 
      longitude:  params[:longitude], 
      latitude:   params[:latitude],
      user:       current_user,
      limit:      5
    })
    render :partial => 'suggestions/list'
  end

  def index
    @suggestions = Suggestion.get({
      time:       params[:time], 
      location:   params[:loc], 
      longitude:  params[:longitude], 
      latitude:   params[:latitude],
      user:       current_user,
      limit:      100
    })
  end

end