Feature: Specify Port
  CrystalForge can be asked to listen on any available tcp port

Scenario: Using the "-p" option
  Given I start `crystalforge server -p 8081 ../../spec/fixtures/apib_files/hello_world.apib`
  When I GET "/messages/motd" from host "http://127.0.0.1:8081"
  Then the http body should include "Hello World!"
  And the http status code should be "200"
  And the content-type should be "text/plain"

Scenario: Using the "--port" option
  Given I start `crystalforge server --port 8081 ../../spec/fixtures/apib_files/hello_world.apib`
  When I GET "/messages/motd" from host "http://127.0.0.1:8081"
  Then the http body should include "Hello World!"
  And the http status code should be "200"
  And the content-type should be "text/plain"
