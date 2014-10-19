Feature: Getting The Version
  Any well behaved application returns it's version from the command line
  with a -v option

Scenario: Using Dash V
  When I run `crystalforge -v`
  Then it should pass with:
  """
  crystalforge version 0.0.1
  """
