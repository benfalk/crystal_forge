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
    end
  end
end
