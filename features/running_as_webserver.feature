Feature: Running as a Webserver (Simple)
  CrystalForge can be run as a webserver to feature test clients against

Scenario Outline: Making Web Requests
  Given I start `crystalforge server <apifile>`
  When I <httpverb> <route> from host "http://127.0.0.1:8080"
  Then the http body should <bodymatch>
  And the http status code should be <code>
  And the content-type should be <content-type>

  Examples:
    | apifile                                         | httpverb | route             | bodymatch              | code  | content-type |
    | ../../spec/fixtures/apib_files/hello_world.apib | GET      | "/messages/motd"  | include "Hello World!" | "200" | "text/plain" |
    | ../../spec/fixtures/apib_files/hello_world.apib | DELETE   | "/messages/motd"  | be blank               | "204" | absent       |
    | ../../spec/fixtures/apib_files/hello_world.apib | GET      | "/random/lol"     | be blank               | "404" | absent       |
    | ../../spec/fixtures/apib_files/hello_world.apib | GET      | "/messages/lol/5" | be blank               | "404" | absent       |
    | ../../spec/fixtures/raml_files/hello_world.raml | GET      | "/messages/motd"  | include "Hello World!" | "200" | "text/plain" |
    | ../../spec/fixtures/raml_files/hello_world.raml | DELETE   | "/messages/motd"  | be blank               | "204" | absent       |
    | ../../spec/fixtures/raml_files/hello_world.raml | GET      | "/random/lol"     | be blank               | "404" | absent       |
    | ../../spec/fixtures/raml_files/hello_world.raml | GET      | "/messages/lol/5" | be blank               | "404" | absent       |

