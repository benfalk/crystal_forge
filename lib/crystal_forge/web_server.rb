require 'rack'

module CrystalForge
  # == Overview
  # Initialized with an api document and attempts to
  # handle web requests to serve the examples described,
  # following the example routes, headers, responses, etc
  class WebServer < RoutingTable
    # The port number to listen on when calling WebServer#start!
    attr_accessor :port, :static_dir

    # == Overview
    # Starts the webserver and begins listening for http
    # requests on port 8080
    def start!
      Rack::Handler::WEBrick.run app, Port: port
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

    def app
      # TODO: before this gets out of hand... please refactor
      if static_dir
        Rack::Static.new(self, root: static_dir, urls: [''])
      else
        self
      end
    end

    def after_initialize
      resource_opts.merge! route_class: Route if resource_opts[:route_class].nil?
      self.port ||= 8080
      self.static_dir ||= nil
    end
  end
end
