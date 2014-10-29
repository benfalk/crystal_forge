require 'uri_template'

module CrystalForge
  class WebServer
    class Route < DocumentParser::SimpleRoute
      def matches?(env)
        env['REQUEST_METHOD'].downcase == method.downcase &&
        path_matches?(env['PATH_INFO'])
      end

      def response
        [proto_response.name, proto_headers, [proto_response.body]]
      end

      private

      def path_matches?(path)
        tpl.extract(path) != nil
      end

      def tpl
        URITemplate.new(uri_template)
      end

      def action
        resource.actions.find { |a| a.method == method }
      end

      def proto_response
        action.examples.first.responses.first
      end

      def proto_headers
        return {} if proto_response.headers.collection.nil?
        proto_response.headers.collection.reduce({}) do |headers, hashy|
          headers.merge(hashy[:name] => hashy[:value])
        end
      end
    end
  end
end
