require 'redsnow'

module CrystalForge
  ##
  # Used to describe urls parsed from an API Blueprint string
  class RoutingTable
    def initialize(apib)
      @ast = RedSnow.parse(apib).ast
    end

    def pretty_format
      resources.map do |resource|
        resource.actions.map { |a| "#{a.method.rjust(6)} #{resource.uri_template}" }
      end.flatten.join("\n")
    end

    private

    def resources
      ast.resource_groups.map(&:resources).flatten
    end

    attr_reader :ast
  end
end
