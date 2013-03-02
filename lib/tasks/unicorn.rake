# -*- encoding : utf-8 -*-
def colorize(text, color_code)
  "\e[#{color_code}#{text}\e[0m"
end

# standard operating procedure
def grey(text)
  colorize(text, ENV["TTY_GREY"] || "37m")
end

# bad stuff
def red(text)
  colorize(text, ENV["TTY_RED"] || "31m")
end

# good stuff
def green(text)
  colorize(text, ENV["TTY_GREEN"] || "32m")
end

# staging color and for warnings
def yellow(text)
  colorize(text, ENV["TTY_YELLOW"] || "33m")
end

# for boot and important notes
def blue(text)
  colorize(text, ENV["TTY_BLUE"] || "34m")
end

def magenta(text)
  colorize(text, ENV["TTY_MAGENTA"] || "35m")
end

# not at all critical or unimplemented
def purple(text)
  colorize(text, ENV["TTY_PURPLE"] || "36m")
end

namespace :unicorn do

  def unicorn
    'unicorn'
  end

  def config_dir
    Rails.root.join('config')
  end

  desc "Return status of the application"
  task :status => :obtain_pid do
    puts blue(system("ps aux | grep #{@pid}"))
  end

  desc "Starts application"
  task :start do
    Dir.chdir(Rails.root) do
      if system("#{unicorn} -c #{config_dir}/unicorn.rb -D")
        puts grey("started application!")
      else
        puts red("failed to start application!")
      end
    end
  end

  desc "Stops application"
  task :stop => :obtain_pid do
    begin
      raise Errno::ENOENT unless @pid

      Process.kill("TERM", @pid)
      sleep 1

      if !File.exists?(@pid_file)
        puts grey("stopped application!")
      else
        puts red("failed to stop application!")
      end
    rescue Errno::ENOENT, Errno::ESRCH
      puts red("No such process, stale pidfile?")
    end
  end

  desc "Restarts application"
  task :restart do
    Rake::Task['unicorn:stop'].invoke
    Rake::Task['unicorn:start'].invoke
  end

  desc "Gracefully stops application"
  task :graceful_stop => :obtain_pid do
    puts grey("Sending QUIT to the unicorn master process")
    Process.kill("QUIT", @pid)
  end

  # Any explanation you need can be found here:
  # http://unicorn.bogomips.org/SIGNALS.html
  #
  desc "Gracefully restarts application"
  task :graceful_restart => :obtain_pid do
    puts grey("Okay, I'm going to try a graceful restart\nif anything goes awry I'll let you know")

    begin
      raise Errno::ENOENT unless @pid

      puts grey("Sending USR2 to the unicorn master process")
      Process.kill("USR2", @pid)

      until File.exists?("#{@pid_file}.oldbin")
        puts grey("I'm waiting for the new master process to boot")
        sleep 3
      end

      puts grey("Sending WINCH to the old master process, only new workers will process requests")
      Process.kill("WINCH", @pid)

      # TODO Some step here should verify everything is okay
      # UPDATE! use unicorn.whatever.conf.rb for this! its got the hooks!
      everything_is_okay = true

      if everything_is_okay
        puts grey("Sweet! Sending QUIT to the old master process")
        Process.kill("QUIT", @pid)

        until !File.exists?("#{@pid_file}.oldbin")
          puts grey("I'm waiting for the new master process to fully takeover")
          sleep 3
        end

        puts green("application gracefully restarted!")
      else
        puts red("Oh no!!! Something is wrong!\nI'm going to send HUP to the old master process\nIts workers will handle requests once again")
        Process.kill("HUP", @pid)

        puts blue("Sending QUIT to the new master process!")
        # reread the pidfile as it has the id of the new master process here
        Process.kill("QUIT", `cat #{@pid_file}`)

        puts red("application graceful restart failed!")
      end

    rescue Errno::ENOENT, Errno::ESRCH
      puts "No process found, I'll just invoke start!"
      Rake::Task["unicorn:start"].invoke
    end
  end

  desc "Returns the unicorn master processes pid or nil if not running"
  task :obtain_pid do
    Dir.chdir(Rails.root) do
      @pid_file = "/var/www/humblesuggestions/tmp/pids/unicorn.pid"
      @pid      = File.exists?(@pid_file) ? `cat #{@pid_file}`.to_i : nil
    end
  end
end
