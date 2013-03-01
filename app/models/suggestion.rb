require 'net/http'
require 'ostruct'

class OpenStruct
  def as_json(options = nil)
    @table.as_json(options)
  end
end

class Suggestion < Array

  attr_accessor :contexts

  WUNDERGROUND_API_KEY = "5df2731cbefe882d"

  def self.get(options = {})
    # collect the inputs
    @user      = options[:user]
    @time      = options[:time]      || 2.hours
    @location  = options[:location]  || (@user.last_location if @user)
    @longitude = options[:longitude] || (@user.last_longitude if @user)
    @latitude  = options[:latitude]  || (@user.last_latitude if @user)

    @weather = nil

    if @longitude && @latitude
      begin
        coordinates  = [@latitude, @longitude].join(',')
        wunderground = URI("http://api.wunderground.com/api/#{WUNDERGROUND_API_KEY}/hourly/q/#{coordinates}.json")
        wunderground_response = JSON.parse(Net::HTTP.get(wunderground))
        @weather = wunderground_response["hourly_forecast"].map{|w| w["condition"].downcase}[0..3]
      rescue Exception => e
        puts "error getting weather #{e.message} #{e.backtrace}"
        @weather = nil
      end
    end

    # now find matching activities
    
    # apply hard filters first...

    # use time context first
    # time_required = ContextOption
    #   .where(:context_id => Context.time_required.id)
    #   .where(:name => time)

    # time_appropriate_idea_weights = IdeaWeight
    #   .where(:context_option_id => time_required.id)
    #   .where('weight > 0')

    # Idea.where().each do |idea|
    # end

    # return matching activities in a weight-ranked array
    suggestions =  Suggestion.new

    # add the contexts
    suggestions.contexts = {
      weather: @weather
    }

    # then the suggestions
    @user.content_suggestions.
      select('*, SQRT(CAST(content_suggestions.position as double precision)*10) * CAST(content_suggestions.rating as double precision)^2 as weight').
      order('weight desc').
      limit(5).each do |content|

      suggestions << OpenStruct.new({
        idea: content.title, 
        weight: content.weight, 
        description: content.description, 
        image: content.image, 
        provider: content.content_provider, 
        type: content.content_type,
        link: content.content_link
      })
    end

    suggestions
  end
end