module CrystalForge
  class WebServer
    ##
    # Wrapper class that converts a raw api described response
    # into more concise parts that make sense for HTML
    class Response
      ##
      # :args:
      #   [raw_response]
      #     The raw ast response object
      #   [env]
      #     optional rack env, un-used but privately available
      #     to subclasses as `env`
      def initialize(opts = {})
        @raw = opts.fetch(:raw_response) { fail ArgumentError }
        @env = opts.fetch(:env) { Hash.new }
      end

      ##
      # HTML status code, eq `200`, `404`, `302`
      def status_code
        raw.name
      end

      ##
      # Hash of key value pairs to be sent as HTML Headers
      def headers
        return {} if raw.headers.collection.nil?
        raw.headers.collection.reduce({}) do |headers, hashy|
          headers.merge(hashy[:name] => hashy[:value])
        end
      end

      ##
      # the data payload to be sent as the body html
      def body
        raw.body
      end

      ##
      # A compabable response expected by Rack that it can
      # send to a client
      def to_rack_response
        [status_code, headers, [body]]
      end

      private

      attr_reader :raw, :env
    end
  end
end
