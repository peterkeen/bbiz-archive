require 'dotenv'
Dotenv.load

require './app'

use Rack::ShowExceptions
run BootstrapArchiveApp.new
