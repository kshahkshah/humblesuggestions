require 'resque/pool/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] ||= '*'

  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end

task "resque:pool:setup" do
  # close any sockets or files in pool manager
  ActiveRecord::Base.connection.disconnect! if ActiveRecord::Base.connected?
  # and re-open them in the resque worker parent
  Resque::Pool.after_prefork do |job|
    settings = YAML.load(File.open(File.join(Rails.root, 'config/database.yml')))[Rails.env]
    ActiveRecord::Base.establish_connection(settings)
  end
end