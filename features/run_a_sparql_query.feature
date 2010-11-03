Feature: Run a SPARQL query
  In order to obtain results from MySparql
  As a MySparql user
  I need to be able to visit a MySparql URL and obtain query results

  Background:
    Given there are no queries
    And I have created a MySparql query of "SELECT * WHERE { ?s ?p ?o }" for data source "http://www.example.com/sparql"

  Scenario: Run a saved MySparql query
    When I visit the latest MySparql query
    Then I should get the query results in JSON 

