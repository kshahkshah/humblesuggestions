require 'net/http'

class Suggestion
  WUNDERGROUND_API_KEY = "5df2731cbefe882d"

  def self.get(options = {})
    # collect the inputs
    time      = options[:time]
    location  = options[:location]
    longitude = options[:longitude]
    latitude  = options[:latitude]

    weather = nil

    if longitude && latitude
      begin
        coordinates  = [latitude, longitude].join(',')
        wunderground = URI("http://api.wunderground.com/api/#{WUNDERGROUND_API_KEY}/hourly/q/#{coordinates}.json")
        weather = JSON.parse(Net::HTTP.get(wunderground))
        next_few_hours = weather["hourly_forecast"].map{|w| w["condition"].downcase}[0..3]
      rescue
        weather = nil
      end
    end

    # now find matching activities
    
    # apply hard filters first...

    # use time context first
    time_required = ContextOption
      .where(:context_id => Context.time_required.id)
      .where(:name => time)

    time_appropriate_idea_weights = IdeaWeight
      .where(:context_option_id => time_required.id)
      .where('weight > 0')

    Idea.where().each do |idea|
      
    end

    # return matching activities in a weight-ranked array
    suggestions = []
    suggestions << {time: 15, idea: 'read magazine article', weight: 10}
    suggestions << {time: 15, idea: 'call mom', weight: 5}
    suggestions
  end
end