require 'redsnow'
require 'crystal_forge/document_parser/resource'
require 'crystal_forge/document_parser/ast'

module CrystalForge
  ##
  # = Document Parser
  # Responsible for taking an api string and providing
  # information about it
  class DocumentParser
    # == Parameters
    # * api : an api blueprint or raml string
    def initialize(api)
      @ast = RedSnow.parse(api).ast
      @resource_opts = {}
      after_initialize
    end

    # == Overview
    # Array of resources generated with the resource options
    # initialized by the DocumentParser
    def resources
      ast_resources.map { |r| Resource.new(r, resource_opts) }
    end

    private

    # == Overview
    # Can be called by sub classes to extend functionality
    # and not have to couple into calling initialize
    def after_initialize
    end

    def ast_resources
      ast.resource_groups.map(&:resources).flatten
    end

    attr_reader :ast, :resource_opts
  end
end
