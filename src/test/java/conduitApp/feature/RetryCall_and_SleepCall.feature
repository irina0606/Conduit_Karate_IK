Feature: Retry call and Sleep call

  Background: Define URL and Token
    * url apiUrl


#  Scenario: Retry call
#    * configure retry = {count: 3, offset: 5000}
#
#    Given params {limit: 10, offset: 0}
#    Given path 'articles'
#    And retry until response.articles[0].favoritesCount == 14
#    When method Get
#    Then status 200
#
#  Scenario: Sleep call
#    * def sleep = function(pause){ java.lang.Thread.sleep(pause) }
#
#    Given params {limit: 10, offset: 0}
#    Given path 'articles'
#    * eval sleep (2000)
#    When method Get
#    Then status 200
