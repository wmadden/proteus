Feature: DocumentParser
  In order to render documents
  As a Proteus user
  I need to be able to parse documents
  
  Scenario: parse empty scalar
    Given document blank
    When I parse the document
    Then I should have nil
  
  Scenario: parse empty list
    Given document []
    When I parse the document
    Then I should have []
  
  Scenario: parse list of scalars
    # Expect list back
  
  Scenario: parse list of components
    # Expect list of component instances
  
  Scenario: parse mixed list
    # Expect list of scalars and component instances
  
  Scenario: parse empty hash
    # Expect empty hash
  
  Scenario: parse hash of scalars to scalars
    # Expect hash back
  
  Scenario: parse hash of component to hash
    # Expect component with params
  
  Scenario: parse hash of component to list
    # Expect component with list
  
  Scenario: parse hash of multiple components
    # Expect fail
  
  Scenario: parse mixed hash of components and scalars
    # Expect fail
