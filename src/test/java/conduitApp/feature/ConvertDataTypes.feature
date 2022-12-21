Feature: Convert Dta Types
  Background: Define URL and Token
    * url apiUrl


  Scenario: Number to String
    * def foo = 10
    * def json = {"bar": #(foo+'')}
    * match json =={"bar": '10'}

  Scenario: String to Number (1)
    * def foo = '10'
    * def json = {"bar": #(foo*1)}
    * match json =={"bar": 10}

  Scenario: String to Number (2)
    * def foo = '10'
    * def json = {"bar": #(~~parseInt(foo))}       // tilda allows to avoid decimal
    * match json =={"bar": 10}

