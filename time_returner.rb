class TimeReturner
  TIME_FORMAT = { year: "year",
                  month: "month",
                  day: "day",
                  hour: "hour",
                  minute: "min",
                  second: "sec" }.freeze

  def initialize(params_string)
    @params = params_string.split(',')
    time_process
  end

  def time_process
    @incorrect_params = []
    @result_time = []
    time = Time.new
    @params.each do |param|
      if TIME_FORMAT[param.to_sym]
        @result_time << time.send(TIME_FORMAT[param.to_sym])
      else
        @incorrect_params << param
      end
    end
  end

  def result
    return if unknown_params?
    @result_time.join('-')
  end

  def unknown_params?
    @incorrect_params.any?
  end

  def unknown_params
    @incorrect_params
  end
end

