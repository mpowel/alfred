source 'https://rubygems.org'

gem 'sinatra'
gem 'json'
gem 'shotgun'
gem "rake"
gem 'activerecord'
gem 'sinatra-activerecord' # excellent gem that ports ActiveRecord for Sinatra
gem 'activesupport'

gem 'haml'
gem 'slack-ruby-client'
gem 'httparty'
# gem 'validates_phone_number'
# gem 'contextio'

# to avoid installing postgres use 
# bundle install --without production

group :development, :test do
  gem 'sqlite3'
  gem 'dotenv'
end

group :production do
  gem 'pg'
end