require 'rack'

module CrystalForge
  # == Overview
  # Initialized with an api document and attempts to
  # handle web requests to serve the examples described,
  # following the example routes, headers, responses, etc
  class WebServer < DocumentParser
    # == Overview
    # Starts the webserver and begins listening for http
    # requests on port 8080
    def start!
      Rack::Handler::WEBrick.run self, Port: 8080
    end
  end
end
