require 'tty'
require 'resque/pool/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] ||= '*'

  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end

namespace :resque do
  namespace :pool do

    task :setup do
      # close any sockets or files in pool manager
      ActiveRecord::Base.connection.disconnect! if ActiveRecord::Base.connected?
      # and re-open them in the resque worker parent
      Resque::Pool.after_prefork do |job|
        settings = YAML.load(File.open(File.join(Rails.root, 'config/database.yml')))[Rails.env]
        ActiveRecord::Base.establish_connection(settings)
      end
    end

    desc "Starts resque pool"
    task :start => :obtain_pid do
      "resque-pool"
    end

    desc "Gracefully restarts resque pool and its workers"
    task :graceful_restart => :obtain_pid do
      puts grey("Okay, I'm going to try a graceful restart")

      puts grey("Sending HUP to the resque pool")
      Process.kill("HUP", @pid)
    end

    desc "Returns the unicorn master processes pid or nil if not running"
    task :obtain_pid do
      Dir.chdir(Rails.root) do
        @pid_file = "/var/www/humblesuggestions/tmp/pids/resque-pool.pid"
        @pid      = File.exists?(@pid_file) ? `cat #{@pid_file}`.to_i : nil
      end
    end

  end
end