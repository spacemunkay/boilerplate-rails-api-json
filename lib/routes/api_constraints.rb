# If you want to implement versioning via HTTP header, add this in your routes:
# scope module: :v1,
#              constraints: ApiConstraints.new(version: 1, default: true) do
# From: http://apionrails.icalialabs.com/book/chapter_two

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
