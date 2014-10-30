module CrystalForge
  class DocumentParser
    # == Overview
    # Simple wrapper for an action found on a resource
    #
    # == Methods
    # * resource : the raw resource from RedSnow
    # * method : the http verb to match this route
    # * uri_template : the http uri pattern to map to
    SimpleRoute = Struct.new(:resource, :method) do
      extend Forwardable
      def_delegators :resource, :uri_template

      private

      def action
        resource.actions.find { |a| a.method == method }
      end
    end

    ##
    # = Document Resource
    # A logical representation of a reachable web address
    # described in an API document.  A resource is confined to
    # only one web uri template but may have multiple routes
    class Resource
      def initialize(raw_resource, opts = {})
        @raw = raw_resource
        @route_class = opts.fetch(:route_class) { SimpleRoute }
      end

      ##
      # = Routes
      # Array of routes that this API resource responds to,
      # each item in the collection should be a duct-type of
      # SimpleRoute
      def routes
        raw.actions.map do |raw_action|
          route_class.new(raw, raw_action.method)
        end
      end

      private

      attr_reader :raw, :route_class
    end
  end
end
