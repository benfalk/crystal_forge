require 'redsnow'
require 'crystal_forge/document_parser/resource'

module CrystalForge
  ##
  # = Document Parser
  # Responsible for taking an api string and providing
  # information about it
  class DocumentParser
    def initialize(apib)
      @ast = RedSnow.parse(apib).ast
    end

    def resources
      ast_resources.map { |r| Resource.new(r) }
    end

    private

    def ast_resources
      ast.resource_groups.map(&:resources).flatten
    end

    attr_reader :ast
  end
end
