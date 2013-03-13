#
# set :output, "/path/to/my/cron_log.log"
#
every 1.day, at: '8:00 AM' do
  runner "Resque.enqueue(UpdateQueues)"
end

every :weekday, at: '5:00 PM' do
  runner "Resque.enqueue(EmailDispatcher)"
end
