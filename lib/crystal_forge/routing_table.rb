require 'redsnow'

module CrystalForge
  ##
  # Describes urls parsed from an API string
  class RoutingTable < DocumentParser
    ##
    # Returns a formatted string of routes found with
    # the initialized file, the format is of the format:
    # # METHOD /uri_template
    def pretty_format
      resources.map do |resource|
        resource.actions.map { |a| "#{a.method.rjust(6)} #{resource.uri_template}" }
      end.flatten.join("\n")
    end
  end
end
