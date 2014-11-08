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

      def non_empty_resources(resource = @raml)
        resource.resources.reduce([]) do |resources, r|
          resources << r if r.methods.any?
          resources.concat non_empty_resources(r)
        end
      end

      class RawResource
        def initialize(node)
          @node = node
          node.methods.each { |m| m.method.upcase! }
        end

        def actions
          node.methods.map { |method| RawAction.new(method) }
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

      class RawAction
        def initialize(action)
          @action = action
        end

        def examples
          action.responses.map { |response| RawExample.new(response) }
        end

        def method
          action.method.upcase
        end

        private

        attr_reader :action
      end

      class RawExample
        def initialize(response)
          @response = response
        end

        def responses
          return [RawResponse.new(nil, response)] if response.bodies.empty?
          response.bodies.map { |body| RawResponse.new(body, response) }
        end

        private

        attr_reader :response
      end

      class RawResponse
        def initialize(raw_body, response)
          @raw_body = raw_body
          @response = response
        end

        def name
          response.code.to_s
        end

        def body
          return '' if raw_body.nil?
          raw_body.example
        end

        def headers
          self
        end

        def collection
          return [] if raw_body.nil?
          [{ name: 'Content-Type', value: raw_body.content_type }]
        end

        private

        attr_reader :raw_body, :response
      end
    end
  end
end
