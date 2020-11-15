require_relative 'time_app'

use Rack::Reloader
use Rack::ContentType, "text/plain"
run Rack::URLMap.new "/time" => TimeApp.new

