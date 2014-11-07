Feature: Running as a Webserver
  CrystalForge can be run as a webserver to feature test clients against

Scenario: Placing a matching GET request
  Given I start `crystalforge server ../../spec/fixtures/apib_files/hello_world.apib`
  When I GET "/messages/motd" from host "http://127.0.0.1:8080"
  Then the http body should include "Hello World!"
  And the http status code should be "200"
  And the content-type should be "text/plain"

Scenario: Placing a matching DELETE request 
  Given I start `crystalforge server ../../spec/fixtures/apib_files/hello_world.apib`
  When I DELETE "/messages/motd" from host "http://127.0.0.1:8080"
  Then the http body should be blank
  And the http status code should be "204"
  And the content-type should be absent

Scenario: Placing a mis-matching GET request 
  Given I start `crystalforge server ../../spec/fixtures/apib_files/hello_world.apib`
  When I GET "/random/lol" from host "http://127.0.0.1:8080"
  Then the http body should be blank
  And the http status code should be "404"
  And the content-type should be absent

Scenario: Placing a mis-matching but close GET request 
  Given I start `crystalforge server ../../spec/fixtures/apib_files/hello_world.apib`
  When I GET "/widgets/dink/it" from host "http://127.0.0.1:8080"
  Then the http body should be blank
  And the http status code should be "404"
  And the content-type should be absent

Scenario: Placing a matching GET request
  Given I start `crystalforge server ../../spec/fixtures/raml_files/hello_world.raml`
  When I GET "/messages/motd" from host "http://127.0.0.1:8080"
  Then the http body should include "Hello World!"
  And the http status code should be "200"
  And the content-type should be "text/plain"

@wip
Scenario: Placing a matching DELETE request 
  Given I start `crystalforge server ../../spec/fixtures/raml_files/hello_world.raml`
  When I DELETE "/messages/motd" from host "http://127.0.0.1:8080"
  Then the http body should be blank
  And the http status code should be "204"
  And the content-type should be absent

Scenario: Placing a mis-matching GET request 
  Given I start `crystalforge server ../../spec/fixtures/raml_files/hello_world.raml`
  When I GET "/random/lol" from host "http://127.0.0.1:8080"
  Then the http body should be blank
  And the http status code should be "404"
  And the content-type should be absent

Scenario: Placing a mis-matching but close GET request 
  Given I start `crystalforge server ../../spec/fixtures/raml_files/hello_world.raml`
  When I GET "/widgets/dink/it" from host "http://127.0.0.1:8080"
  Then the http body should be blank
  And the http status code should be "404"
  And the content-type should be absent
