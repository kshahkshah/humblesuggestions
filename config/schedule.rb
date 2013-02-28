#
# set :output, "/path/to/my/cron_log.log"
#
every 1.day, at: '3:00 AM' do
  runner "Resque.enqueue(UpdateQueues)"
end

every 5.minutes do
  runner "Resque.enqueue(DispatchEmails)"
end
