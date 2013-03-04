source 'http://rubygems.org'

# core
gem 'rails', '3.2.11'

# storage
gem 'mysql2'
gem 'redis'

# background jobs
gem 'whenever'
gem 'resque'
gem 'resque-pool'

# front end
gem 'jquery-rails'
gem 'haml'

# statistics
# gem 'statsample'
# gem 'gsl', :git => 'git://github.com/whistlerbrk/rb-gsl.git'

# authentication
gem 'devise'
gem 'omniauth'

# services
gem 'netflix', :git => "git://github.com/whistlerbrk/netflix-ruby.git"
gem 'omniauth-netflix'

gem 'instapaper'
gem 'omniauth-instapaper'

group :production do
  gem 'unicorn'
  gem 'exception_notification'
  gem 'resque-failed-job-mailer'
end

group :development do
  gem 'annotate'
  gem 'debugger'
  gem 'pry'
  gem 'mailcatcher'
end

# staging/production
group :assets do
  gem 'therubyracer', '0.11.4'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
