require 'rack'

module CrystalForge
  # == Overview
  # Initialized with an api document and attempts to
  # handle web requests to serve the examples described,
  # following the example routes, headers, responses, etc
  class WebServer < RoutingTable
    # == Overview
    # Starts the webserver and begins listening for http
    # requests on port 8080
    def start!
      Rack::Handler::WEBrick.run self, Port: 8080
    end

    # == Overview
    # Returns a valid rack formatted response when given
    # a Rack environment.  In the event no route matches
    # an environment request it will return a `nomatch_response`
    def call(env)
      route = routes.find { |r| r.matches? env }
      if route
        route.rack_response
      else
        nomatch_response
      end
    end

    # == Overview
    # The rack response to send when no match is found
    def nomatch_response
      ['404', {}, ['']]
    end

    private

    def after_initialize
      resource_opts.merge! route_class: Route if resource_opts[:route_class].nil?
    end
  end
end
