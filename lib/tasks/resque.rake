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
    task :start do
      Dir.chdir(Rails.root) do
        if system("resque-pool --daemon --environment #{Rails.env}")
          puts grey("started resque-pool!")
        else
          puts red("failed to start resque-pool!")
        end
      end
    end

    desc "Gracefully restarts resque pool and its workers"
    task :graceful_restart => :obtain_pid do
      puts grey("Okay, I'm going to try a graceful restart\nif anything goes awry I'll let you know")

      begin
        raise Errno::ENOENT unless @pid

        puts grey("Sending QUIT to the resque-pool")
        Process.kill("QUIT", @pid)
        count = 0

        if File.exists?(@pid_file)
          if count.eql?(20)
            puts red("resque pool or its children have NOT exited. Going hard")
            Process.kill("TERM", @pid)
          else
            puts grey("I'm waiting for resque-pool to exit")
            sleep 3
          end

          count = count + 1
        end

        puts "Starting new resque pool process..."
        Rake::Task["resque:pool:start"].invoke

      rescue Errno::ENOENT, Errno::ESRCH
        puts "No process found, I'll just invoke start!"
        Rake::Task["resque:pool:start"].invoke
      end
    end

    desc "Returns the unicorn master processes pid or nil if not running"
    task :obtain_pid do
      Dir.chdir(Rails.root) do
        @pid_file = File.join(Rails.root, 'tmp/pids/resque-pool.pid')
        @pid      = File.exists?(@pid_file) ? `cat #{@pid_file}`.to_i : nil
      end
    end

  end
end