require 'coveralls'
require 'rspec/its'
require 'pry'
Coveralls.wear!
require 'crystal_forge'

HELLO_WORLD_APIB = "#{File.dirname(__FILE__)}/fixtures/apib_files/hello_world.apib"
