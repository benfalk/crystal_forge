require 'redsnow'
require 'crystal_forge/document_parser/resource'

module CrystalForge
  ##
  # = Document Parser
  # Responsible for taking an api string and providing
  # information about it
  class DocumentParser
    # == Parameters
    # * apib : an api blueprint string
    # * parser_opts : hash of options for the parser
    #   * :resource : Resource#initialize hash of options, defaults
    #     to an empty hash
    def initialize(apib, parser_opts = {})
      @ast = RedSnow.parse(apib).ast
      @resource_opts = parser_opts.fetch(:resource) { Hash.new }
    end

    # == Overview
    # Array of resources generated with the resource options
    # initialized by the DocumentParser
    def resources
      ast_resources.map { |r| Resource.new(r, @resource_opts) }
    end

    private

    def ast_resources
      ast.resource_groups.map(&:resources).flatten
    end

    attr_reader :ast
  end
end
