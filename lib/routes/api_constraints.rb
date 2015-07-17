module Routes
  class ApiConstraints
    def initialize(options)
      @version = options[:version]
      @default = options[:default]
    end

    def matches?(req)
      @default || req.headers['Accept'].include?("application/#{APP_NAME.downcase}.v#{@version}")
    end
  end
end
