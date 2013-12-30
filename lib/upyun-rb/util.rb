module Upyun
  class Util
    class << self
      def current_date
        Time.now.utc.strftime('%a, %d %b %Y %H:%M:%S GMT')
      end
    end
  end
end
