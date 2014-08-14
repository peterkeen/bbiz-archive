require 'dotenv'
Dotenv.load

require './app'

use Rack::ShowExceptions

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == ENV['USERNAME'] and password == ENV['PASSWORD']
end

run BootstrapArchiveApp.new
