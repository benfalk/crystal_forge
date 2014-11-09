require 'crystal_forge/document_parser/resource'
require 'crystal_forge/document_parser/ast'

module CrystalForge
  ##
  # = Document Parser
  # Responsible for taking an api string and providing
  # information about it
  class DocumentParser
    ##
    # Initialize document parser with an api string
    # @param [String] api
    def initialize(api)
      @ast = AST.parse(api)
      @resource_opts = {}
      after_initialize
    end

    ##
    # Array of resources generated with the resource options
    # initialized by the DocumentParser
    # @return [Array<Resource>]
    def resources
      ast.resources.map { |r| Resource.new(r, resource_opts) }
    end

    private

    ##
    # Can be called by sub classes to extend functionality
    # and not have to couple into calling initialize
    def after_initialize
    end

    attr_reader :ast, :resource_opts
  end
end
