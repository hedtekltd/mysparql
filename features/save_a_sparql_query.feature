Feature: Save a SPARQL query
  In order to provide query URIs
  As an API provider
  I need to save queries through an API request

  Scenario: API request has complete information
    When I POST the query "SELECT * WHERE { ?s ?p ?o }" and source "http://test.host/sparql"
    Then I should get a MySparql JSON encoded URI as a response

  Scenario: API request is missing a data source
    When I POST the query "SELECT * WHERE { ?s ?p ?o }" with no source
    Then I should get a JSON error "Source can't be blank"