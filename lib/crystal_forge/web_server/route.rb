require 'addressable/template'

module CrystalForge
  class WebServer
    class Route < DocumentParser::SimpleRoute
      def matches?(env)
        env['REQUEST_METHOD'].downcase == method.downcase &&
          path_matches?(env['PATH_INFO'])
      end

      def rack_response
        Response.new(raw_response: raw_response).to_rack_response
      end

      private

      def path_matches?(path)
        tpl.extract(path) != nil
      end

      def tpl
        Addressable::Template.new(uri_template)
      end

      def raw_response
        action.examples.first.responses.first
      end
    end
  end
end
