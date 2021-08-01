require_relative 'time_returner'

class TimeApp
  def initialize
    @response = Rack::Response.new
  end

  def call(env)
    @request = Rack::Request.new(env)
    create_answer
    @response.finish
  end

  private

  def create_answer
    TimeReturner.call(@request.params['format'])
    if TimeReturner.success?
      @response.body = [TimeReturner.result]
    else
      @response.status = 400
      @response.body =
        ["Unknown time format #{TimeReturner.error}"]
    end
  end
end
