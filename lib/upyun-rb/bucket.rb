module Upyun
  class Bucket
    def initialize(bucket, operator, password, options={})
      upyun_host = options[:upyun_host] || "http://v0.api.upyun.com"

      pool    = options[:pool] || 2
      timeout = options[:timeout] || 10

      @bucket = bucket
      @operator = operator
      @signed_password = Digest::MD5.hexdigest(password)

      @pool = ConnectionPool.new(size: pool, timeout: timeout) do
        Faraday.new(:url => upyun_host) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
      end
    end

    def head(path)
      uri = "/#{@bucket}/#{path}"
      date = Upyun::Util.current_date
      sign = Digest::MD5.hexdigest("HEAD&#{uri}&#{date}&0&#{@signed_password}")

      @pool.with do |conn|
        conn.head do |req|
          req.url uri
          req.headers['Authorization'] = "UpYun #{@operator}:#{sign}"
          req.headers['Date'] = date
          req.headers['Expect'] = ''
        end
      end
    end

    def put(path, file)
      uri = "/#{@bucket}/#{path}"
      date = Upyun::Util.current_date
      mime_type = `file -b --mime #{file}`.gsub(/\n/,"").split(';')[0]
      file_size = file.nil? ? 0 : File.size(file)
      sign = Digest::MD5.hexdigest("PUT&#{uri}&#{date}&#{file_size}&#{@signed_password}")

      @pool.with do |conn|
        conn.put do |req|
          req.url uri
          req.body = Faraday::UploadIO.new(file, mime_type)
          req.headers['Mkdir'] = 'true'
          req.headers['Content-Type'] = mime_type
          req.headers['Content-Length'] = file_size.to_s
          req.headers['Authorization'] = "UpYun #{@operator}:#{sign}"
          req.headers['Date'] = date
          req.headers['Expect'] = ''
        end
      end
    end

    def delete(path)
      uri = "/#{@bucket}/#{path}"
      date = Upyun::Util.current_date
      sign = Digest::MD5.hexdigest("DELETE&#{uri}&#{date}&0&#{@signed_password}")

      @pool.with do |conn|
        conn.delete do |req|
          req.url uri
          req.headers['Authorization'] = "UpYun #{@operator}:#{sign}"
          req.headers['Date'] = date
          req.headers['Expect'] = ''
        end
      end
    end
  end
end
