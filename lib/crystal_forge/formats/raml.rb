require 'raml-rb'
require 'ostruct'

module CrystalForge
  module Formats
    ##
    # RAML ast that can convert a raml based document into a similiar structure
    # that is used with Crystal Forge
    class RAML < DocumentParser::AST
      HEADER_REGEX = /\A\#%RAML 0.8/

      ##
      # Determines if the given document could be used
      # @param [String] document api string to analyze
      # @param [Hash] _opts unused options
      # @return [true, false]
      def self.understands?(document, _opts = {})
        document.scan(HEADER_REGEX).size == 1
      end

      ##
      # @param [String] document
      def initialize(document)
        @raml = Raml::Parser.parse(document)
      end

      ##
      # @return [Array<RawResource>]
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

      ##
      # Wrapper for resources from the raml parser that follow the
      # same signiture as an API blueprint resource
      class RawResource
        ##
        # @param [Raml::Resource] node
        def initialize(node)
          @node = node
          node.methods.each { |m| m.method.upcase! }
        end

        ##
        # @return [Array<RAML::RawAction>]
        def actions
          node.methods.map { |method| RawAction.new(method) }
        end

        ##
        # @example
        #   "/widgets/{id}"
        #
        # @return [String]
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

      ##
      # Wrapper object that gives each raml method the same duct type
      # as an api blueprint action
      class RawAction
        ##
        # @param [Raml::Method] action
        def initialize(action)
          @action = action
        end

        ##
        # @return [Array<RawExample>]
        def examples
          action.responses.map { |response| RawExample.new(response) }
        end

        ##
        # @example
        #   "GET"
        #
        # @return [String] representing http verb
        def method
          action.method.upcase
        end

        private

        attr_reader :action
      end

      ##
      # Wraps a given raml response to have the same duct type
      # as an api blueprint example
      class RawExample
        ##
        # Empty body to send when no bodies are found
        NullBody = ::OpenStruct.new(example: '', content_type: '').freeze

        ##
        # @param [Raml::Response] response
        def initialize(response)
          @response = response
          @bodies = response.bodies.empty? ? [NullBody] : response.bodies
        end

        ##
        # @return [Array<RAML::RawResponse>]
        def responses
          bodies.map { |body| RawResponse.new(body, response) }
        end

        private

        attr_reader :response, :bodies
      end

      ##
      # response that is similiar to an API blueprint response
      class RawResponse
        ##
        # @param [Raml::Body] raw_body
        # @param [Raml::Response] response
        def initialize(raw_body, response)
          @raw_body = raw_body
          @response = response
        end

        ##
        # @return [String] status html code
        def name
          response.code.to_s
        end

        ##
        # @return [String] html body
        def body
          raw_body.example
        end

        ##
        # @return [RAML::RawResponse, #collection]
        def headers
          self
        end

        ##
        # @example
        #   [{ name: 'Content-Type', value: 'text/html' }]
        # @return [Array<Hash>] array of name, value pair hashes for
        #   html headers
        def collection
          return [] if raw_body.content_type.empty?
          [{ name: 'Content-Type', value: raw_body.content_type }]
        end

        private

        attr_reader :raw_body, :response
      end
    end
  end
end
