Feature: Running as a Webserver
  CrystalForge can be run as a webserver to feature test clients against

Scenario: Placing a matching GET request
  Given I start `crystalforge server ../../apib_files/hello_world.apib`
  When I GET "/messages/motd" from host "http://127.0.0.1:8080"
  Then the http body should include "Hello World!"
  And the http status code should be "200"
  And the content-type should be "text/plain"

@wip
Scenario: Placing a matching DELET request 
  Given I start `crystalforge server ../../apib_files/hello_world.apib`
  When I DELETE "/messages/motd" from host "http://127.0.0.1:8080"
  Then the http body should be blank
  And the http status code should be "204"
  And the content-type should be absent
