module CrystalForge
  class DocumentParser
    SimpleRoute = Struct.new(:uri_template, :method)

    ##
    # = Document Resource
    # A logical representation of a reachable web address
    # described in an API document.  A resource is confined to
    # only one web uri template but may have multiple routes
    class Resource
      def initialize(raw_resource, route_class: SimpleRoute)
        @raw = raw_resource
        @route_class = route_class
      end

      ##
      # = Routes
      # Array of routes that this API resource responds to,
      # each item in the collection should be a duct-type of
      # SimpleRoute
      def routes
        raw.actions.map do |raw_action|
          route_class.new(raw.uri_template, raw_action.method)
        end
      end

      private

      attr_reader :raw, :route_class
    end
  end
end
