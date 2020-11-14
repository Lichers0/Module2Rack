require_relative 'time_returner'

class TimeApp
  def call(env)
    @request = Rack::Request.new(env)
    status, body = process(@request)

    [status, header, [body]]
  end

  private

  def process(request)
    return [404, "Incorrect"] unless correct_request?

    time_returner = TimeReturner.new(request.params['format'])
    return [400, "Unknown time format #{time_returner.unknown_params}"] if time_returner.unknown_params?

    [200, time_returner.result]
  end

  def correct_request?
    method_get? && correct_path?
  end

  def method_get?
    @request.request_method == "GET"
  end

  def correct_path?
    @request.path == "/time"
  end

  def header
    { "Content-Type" => "text/plain" }
  end
end
