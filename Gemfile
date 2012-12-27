source 'https://rubygems.org'

gem 'rails', '3.2.9'
# gem 'mysql2'
# gem 'jdbc-mysql'

if defined?(JRUBY_VERSION)
  gem 'activerecord-jdbc-adapter' #, '=1.1.3'
  gem 'jdbc-mysql', :require=>false
  gem 'activerecord-jdbcmysql-adapter' #, '=1.1.3'
else
  gem 'mysql2'
end

gem 'will_paginate', '~> 3.0'      # For pagination
gem 'bootstrap-will_paginate'      # To fix WillPaginate and TwitterBootstrap


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs readme for more supported runtimes
  if defined?(JRUBY_VERSION)
    gem 'therubyrhino' # For JRuby
  else
    gem 'therubyracer', :platforms => :ruby
  end
  
  gem 'uglifier', '>= 1.0.3'
  # For Twitter Bootstrap:
  gem 'less' #, '2.0.11'
  gem 'less-rails' #, '2.1.8'
  gem 'twitter-bootstrap-rails' #, '2.0.4'
end

gem 'jquery-rails'

gem 'ib-ruby'
gem 'yahoo-finance'
gem 'lazy_high_charts'

gem 'technical_analysis', '0.0.6', :git => 'git://github.com/brianlong/technical_analysis.git'

group :development do
  
  # For local working area:
  gem 'rmagick', :require => false
  gem 'gruff'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

