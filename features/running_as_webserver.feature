Feature: Running as a Webserver
  CrystalForge can be run as a webserver to feature test clients against

@wip
Scenario: Starting Up the Server
  Given I start `crystalforge server ../../apib_files/hello_world.apib`
  When I visit "http://127.0.0.1/messages/motd"
  Then the http body should include "Hellow World!"
  And the http status code should be "200"
  And the content-type should be "text/plain"
