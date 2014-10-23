require 'redsnow'

module CrystalForge
  ##
  # Describes urls parsed from an API string
  class RoutingTable < DocumentParser
    ##
    # Returns a formatted string of routes found with
    # the initialized file, the output is of the format:
    # # METHOD /uri_template
    def pretty_format
      routes.map { |r| "#{r.method.rjust(6)} #{r.uri_template}" }.join("\n")
    end

    ##
    # Returns all routes found from the api document
    def routes
      resources.map(&:routes).flatten
    end
  end
end
