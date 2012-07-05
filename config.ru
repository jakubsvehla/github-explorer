$LOAD_PATH.unshift File.dirname(__FILE__)
require 'bundler'

# external dependencies
Bundler.require

require 'json'

require 'models/category'
require 'models/route'
require 'models/user'
require 'app'

ENV['DATABASE_URL'] ||= 'postgres://localhost/github-explorer'

$redis = Redis.new

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])

use Rack::Session::Cookie

map '/' do
  run Github::Explorer
end

map '/auth' do
  run Github::Auth
end
