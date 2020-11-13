class App
  TIME_FORMAT = { year: "year",
                  month: "month",
                  day: "day",
                  hour: "hour",
                  minute: "min",
                  second: "sec" }.freeze

  def call(env)
    @env =  env
    return response_404 unless correct_request?

    create_answer

    return response_400 if unknown_params?
    response_200
  end

  private

  def create_answer
    params = query_params
    # year, month, day, hour, minute, second
    @incorrect_params = []
    @result_time = []
    time = Time.new
    params.each do |param|
      if TIME_FORMAT[param.to_sym]
        @result_time << time.send(TIME_FORMAT[param.to_sym])
      else
        @incorrect_params << param
      end
    end
  end

  def unknown_params?
    @incorrect_params.any?
  end

  def query_params
    query = URI::decode(@env["QUERY_STRING"])
    query_params = query[/(?<=\=).*/]
    query_params.split(',')
  end

  def correct_request?
    get? && correct_request_path?
  end

  def get?
    @env["REQUEST_METHOD"] == "GET"
  end

  def correct_request_path?
    @env["REQUEST_PATH"] == "/time"
  end

  def response_200
    response(200, "#{@result_time.join('-')}\n")
  end

  def response_400
    response(400, "Unknown time format #{@incorrect_params}\n")
  end

  def response_404
    response(404 , "Incorrect\n")
  end

  def response (status, result_data)
    [
      status,
      { 'Content-Type' => 'text/plain' },
      [result_data]
    ]
  end
end

