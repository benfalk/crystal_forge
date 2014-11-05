require 'raml-rb'

module CrystalForge
  module Formats
    class RAML < DocumentParser::AST
      HEADER_REGEX = /\A\#%RAML 0.8/

      def self.understands?(document, _opts = {})
        document.scan(HEADER_REGEX).size == 1
      end

      def initialize(document)
        @raml = Raml::Parser.parse(document)
      end

      def resources
        non_empty_resources.map { |r| RawResource.new(r) }
      end

      private

      def non_empty_resources
        resources = []
        @raml.resources.each do |resource|
          resources << resource if resource.methods.any?
          resources.concat any_from_below(resource)
        end
        resources
      end

      def any_from_below(resource)
        resources = []
        resource.resources.each do |r|
          resources << r if r.methods.any?
          resources.concat any_from_below(r)
        end
        resources
      end

      class RawResource
        def initialize(node)
          @node = node
          node.methods.each { |m| m.method.upcase! }
        end

        def actions
          node.methods
        end

        def uri_template
          uri_partials.join
        end

        private

        def uri_partials
          partials = [node.uri_partial]
          parent = node
          while parent.parent.is_a?(Raml::Resource)
            parent = parent.parent
            partials << parent.uri_partial
          end
          partials.reverse!
        end

        attr_reader :node
      end
    end
  end
end
