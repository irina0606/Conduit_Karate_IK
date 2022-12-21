Feature: Tests for the Home page

  Background: Define URL and Token
    Given url apiUrl
    * def timeValidator = read ('classpath:helpers/timeValidator.js')

  Scenario: Get all tags
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags contains ['welcome','introduction']
    And match response.tags !contains 'car'
    And match response.tags !contains any ['cat', 'welcome','dog']
    And match response.tags contains only ["implementations","welcome","introduction","codebaseShow","ipsum","qui","et","quia","cupiditate","deserunt"]
    And match response.tags == '#array'
    And match each response.tags == '#string'

  Scenario: Get 10 articles from the page
    Given path 'articles'
    And params {limit: 10, offset: 8}
    When method Get
    Then status 200
    And match response.articles == '#[10]'
    * print response.articles[0].title
    * print response.articles.length

  Scenario: Matching/Fuzzy Matching
    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    * def totalNumberOfArticles = response.articlesCount
    And match response.articles == '#[10]'
    And match response.articlesCount != 0
    And match response.articlesCount != 100
#    And match response == {"articles": "#array", "articlesCount": 193}
    And match response.articles[0].createdAt contains '2022'
    And match response.articles[*].favouritesCount !contains 1   //at least one has value 1
    And match response.articles[*].author.bio contains null     //at least one has value null
    And match response.articles[*]..bio contains null           //it will find any key bio inside the object, doesn`t matter where it is located
    And match each response..following == false                 //it will find each key following inside the object, doesn`t matter where it is located
    And match each response..following == '#boolean'
    And match each response..favouritesCount == '#number'
    And match each response..bio == '##number'                  //it will find each bio. Double hash means the value can be number or null. And double hash sign will find bio or will not fond bio, the assersion will not fail.



  Scenario: Schema verification Get few articles from the page
    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
#    And match response == {"articles": "#[10]", "articlesCount": 193}
    And match each response.articles ==
    """
    {
      "slug": "#string",
      "title": "#string",
      "description": "#string",
      "body": "#string",
      "tagList": "#array",
      "createdAt": "#? timeValidator(_)",
      "updatedAt": "#? timeValidator(_)",
      "favorited": "#boolean",
      "favoritesCount": "#number",
      "author":
      {
        "username": "#string",
        "bio": "##string",
        "image": "##string",
        "following": "#boolean"
      }
    }
    """

  Scenario: Conditional logic
    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    * def favoritesCount = response.articles[0].favoritesCount
    * print favoritesCount