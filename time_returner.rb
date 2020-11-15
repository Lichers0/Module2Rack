class TimeReturner
  DATE_FORMATS = {
    year:   "%Y",
    month:  "%m",
    day:    "%d"
  }.freeze

  TIME_FORMATS = {
    hour: "%H",
    minute: "%M",
    second: "%S"
  }.freeze

  DATE_TIME = DATE_FORMATS.keys + TIME_FORMATS.keys

  class << self
    def call(params_string)
      @params = params_string.split(',').map(&:to_sym)
      p @params
      unsupported_params
    end

    def unsupported_params
      p DATE_TIME
      @unsupported_params ||= @params.select { |param| !DATE_TIME.include?(param) }
    end

    def success?
      @unsupported_params.empty?
    end

    def error
      @unsupported_params
    end

    def result
      @strftime_format = "#{date_strftime} #{time_strftime}"
      Time.now.strftime(@strftime_format)
    end

    private

    def date_strftime
      select_strftime_from(DATE_FORMATS, '-')
    end

    def time_strftime
      select_strftime_from(TIME_FORMATS, ':')
    end

    def select_strftime_from(hash, separator)
      hash.map do |format, strftime|
        @params.include?(format) ? strftime : nil
      end.compact.join(separator)
    end
  end

end

