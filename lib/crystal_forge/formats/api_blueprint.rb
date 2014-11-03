require 'redsnow'

module CrystalForge
  module Formats
    class APIBlueprint < CrystalForge::DocumentParser::AST
      ##
      # Should match lines that start with any number of `#`, followed
      # by zero or more filler characters, with then brackets describing
      # something
      #
      # == Examples
      # # '# Widgets [/widgets]'
      # # '## list [GET]'
      RESOURCE_REGEX = /^(\#+[^\#\[\]]*\[[^\[\]]+\])$/

      ##
      # Returns true if it finds api blueprint parseable resources
      def self.understands?(document, _opts = {})
        document.scan(RESOURCE_REGEX).any?
      end

      ##
      # Expects a valid API Blueprint document for `document`
      def initialize(document)
        @ast = RedSnow.parse(document).ast
      end

      ##
      # Maps resources from all the resource groups found in the ast
      def resources
        @ast.resource_groups.map(&:resources).flatten
      end

      private

      def method_missing(method, *args)
        @ast.public_send(method, *args)
      end
    end
  end
end
