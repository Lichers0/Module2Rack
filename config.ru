require_relative 'time_app'

use Rack::Reloader
run TimeApp.new

