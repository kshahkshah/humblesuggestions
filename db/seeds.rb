# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

time_required = Context.create(name: 'Time Required')
a_few_minutes = ContextOption.create(
  context_id: time_required.id,
  name:       '5'
)
fifteen_minutes = ContextOption.create(
  context_id: time_required.id,
  name:       '15'
)
half_an_hour = ContextOption.create(
  context_id: time_required.id,
  name:       '30'
)
an_hour = ContextOption.create(
  context_id: time_required.id,
  name:       '60'
)
several_hours = ContextOption.create(
  context_id: time_required.id,
  name:       '180'
)

location_context = Context.create(name: 'Location')
home = ContextOption.create(
  context_id: location_context.id,
  name:       'Home'
)
work = ContextOption.create(
  context_id: location_context.id,
  name:       'Work'
)
commuting = ContextOption.create(
  context_id: location_context.id,
  name:       'Commuting'
)

day_of_week_context = Context.create(name: 'Day of Week')
weekdays = ContextOption.create(
  context_id: day_of_week_context.id,
  name:       'Weekdays'
)
weekends = ContextOption.create(
  context_id: day_of_week_context.id,
  name:       'Weekend'
)

time_of_day_context = Context.create(name: 'Time of Day')
early = ContextOption.create(
  context_id: time_of_day_context.id,
  name:       'Early Morning'
)
morning = ContextOption.create(
  context_id: time_of_day_context.id,
  name:       'Morning'
)
noon = ContextOption.create(
  context_id: time_of_day_context.id,
  name:       'Early Afternoon'
)
afternoon = ContextOption.create(
  context_id: time_of_day_context.id,
  name:       'Afternoon'
)
evening = ContextOption.create(
  context_id: time_of_day_context.id,
  name:       'Evening'
)
night = ContextOption.create(
  context_id: time_of_day_context.id,
  name:       'Night'
)

weather_context = Context.create(name: 'Weather')
clear = ContextOption.create(
  context_id: weather_context.id,
  name:       'clear'
)
cloudy = ContextOption.create(
  context_id: weather_context.id,
  name:       'cloudy'
)
rainy = ContextOption.create(
  context_id: weather_context.id,
  name:       'rainy'
)
snowy = ContextOption.create(
  context_id: weather_context.id,
  name:       'snowy'
)

phone_home = Idea.create(
  name: 'Call your family'
)

get_dinner = Idea.create(
  name: 'Figure out dinner plans'
)

schedule_coffee = Idea.create(
  name: 'Schedule an after lunch coffee with a nearby friend tomorrow'
)

read_article = Idea.create(
  name: 'Read an article'
)

watch_colbert = Idea.create(
  name: 'Watch Colbert'
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         time_required.id,
  context_option_id:  half_an_hour.id,
  weight:             5
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         time_of_day_context.id,
  context_option_id:  early.id,
  weight:             0
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         time_of_day_context.id,
  context_option_id:  morning.id,
  weight:             2
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         time_of_day_context.id,
  context_option_id:  noon.id,
  weight:             7
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         time_of_day_context.id,
  context_option_id:  afternoon.id,
  weight:             7
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         time_of_day_context.id,
  context_option_id:  evening.id,
  weight:             8
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         time_of_day_context.id,
  context_option_id:  night.id,
  weight:             5
)

IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         day_of_week_context.id,
  context_option_id:  weekdays.id,
  weight:             8
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         day_of_week_context.id,
  context_option_id:  weekends.id,
  weight:             3
)

IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         location_context.id,
  context_option_id:  work.id,
  weight:             3
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         location_context.id,
  context_option_id:  home.id,
  weight:             7
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         weather_context.id,
  context_option_id:  clear.id,
  weight:             2
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         weather_context.id,
  context_option_id:  cloudy.id,
  weight:             5
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         weather_context.id,
  context_option_id:  rainy.id,
  weight:             7
)
IdeaWeight.create(
  idea_id:            watch_colbert.id,
  context_id:         weather_context.id,
  context_option_id:  snowy.id,
  weight:             9
)


# what if you're at home, so it's better to do this, but the weather is nice...
# should these weights be all things considered independently...
# and then in the logic of each context, I say "well if this other context applies as well, it's causes this X factor"
# if you're at home and inside activity makes sense...
#   if the weather sucks..  -- we can figure that out
#   if it's late..          -- we can figure this out too
#   if you're tired and want to relax   -- we can't figure this out except by your past recent behaviour on site or your schedule, etc
# at the same token, if you're at home and outside activity makes sense...
#   if the weather is great
#   if the sun is out and it's an active activity
#   if the sun isn't out but it's a nighttime activity.. 

# time_required
# location_context
# day_of_week_context
# time_of_day_context
# weather_context
