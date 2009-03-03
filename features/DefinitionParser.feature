Feature: Definition Parser
  In order to instantiate components
  The component parser
  Needs to be able to load component definitions

  Scenario: no definition
    # Expect fail
  
  Scenario: invalid name
    # Expect fail
  
  Scenario: valid name, undefined parent
    # Expect fail
  
  Scenario: scalar, no parent
    # Expect new definition whose concrete class is Component, with no params,
    # children, decorators or template
  
  Scenario: scalar, defined parent
    # Expect new definition with parent's defaults and concrete class, and
    # parent correctly set
  
  Scenario: scalar, valid name, own ancestor
    # Expect recursive definition error
  
  Scenario: scalar, valid name, own parent (non-concrete)
    # Expect recursive definition error
  
  Scenario: scalar, valid name, own parent (concrete)
    # Expect definition with concrete class of parent and no defaults
  
  Scenario: list
    # Expect fail
  
  Scenario: hash, invalid name
    # Expect fail
  
  Scenario: hash, valid name, no parent, empty value
    # Expect new definition whose concrete class is Component, with no defaults
  
  Scenario: hash, valid name, defined parent, empty value
    # Expect definition with parent and parent's defaults
  
  Scenario: hash, valid name, undefined parent
    # Expect fail
