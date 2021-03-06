Feature: Listing Matches
  CrystalForge can list out all urls that it will match against with an API
  Blueprint file(s).

Scenario: Parsing Urls
  When I run `crystalforge routes ../../spec/fixtures/apib_files/hello_world.apib`
  Then it should pass with:
  """
     GET /messages/{id}
  DELETE /messages/{id}
  """

Scenario: Parsing Urls
  When I run `crystalforge routes ../../spec/fixtures/raml_files/hello_world.raml`
  Then it should pass with:
  """
     GET /messages/{id}
  DELETE /messages/{id}
  """
