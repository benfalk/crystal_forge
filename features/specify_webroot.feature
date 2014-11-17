Feature: Specify Web Root
  CrystalForge can attach to a directory to serve static assets

Scenario: Using the "--static" option
  Given I start `crystalforge server --static ../../spec/fixtures/www ../../spec/fixtures/apib_files/hello_world.apib`
  When I GET "crystal.jpg" from host "http://127.0.0.1:8080"
  Then the http status code should be "200"
  And the content-type should be "image/jpeg"
