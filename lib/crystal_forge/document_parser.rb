require 'redsnow'

module CrystalForge
  ##
  # = Document Parser
  # Responsible for taking an api string and providing
  # information about it
  class DocumentParser
    def initialize(apib)
      @ast = RedSnow.parse(apib).ast
    end

    private

    def resources
      ast.resource_groups.map(&:resources).flatten
    end

    attr_reader :ast
  end
end
