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
    @limit     = options[:limit]     || 5
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

    # return matching activities in a weight-ranked array
    suggestions =  Suggestion.new

    # add the contexts
    suggestions.contexts = {
      weather: @weather
    }

    # then the suggestions
    @user.content_items.joins('LEFT OUTER JOIN suggestion_tracks ON suggestion_tracks.content_item_id = content_items.id AND suggestion_tracks.user_id = content_items.user_id').
      select('content_items.*, SQRT(content_items.position*10) * content_items.rating^2 as weight').
      where('suggestion_tracks.id is null or (suggestion_tracks.status <> "removed" and suggestion_tracks.on < (?))', 30.days.ago).
      order('weight desc').limit(@limit).each do |item|

      suggestions << OpenStruct.new({
        idea: item.title, 
        weight: item.weight, 
        description: item.description, 
        image: item.image, 
        provider: item.content_provider, 
        type: item.content_type,
        link: item.content_link,
        item_id: item.id
      })
    end

    suggestions
  end
end