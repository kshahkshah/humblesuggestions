# -*- encoding : utf-8 -*-
# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
worker_processes 2

working_directory File.expand_path('../..', __FILE__)

# Also listen on 3000 for direct conncetions from the local machine. This makes
# it nice and easy to do the curl in config/deploy/backend/3-before_restart.rb.
listen 3000
listen "/run/nginx/nginx.sock", { backlog: 10 }

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

pid "/var/www/humblesuggestions/tmp/pids/unicorn.pid"

# Some applications/frameworks log to stderr or stdout, so prevent them from
# going to /dev/null when daemonized here:
stderr_path "/var/www/humblesuggestions/log/unicorn.stderr.log"
stdout_path "/var/www/humblesuggestions/log/unicorn.stdout.log"

# combine REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  #addr = "127.0.0.1:#{3000 + worker.nr}"
  #server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end
