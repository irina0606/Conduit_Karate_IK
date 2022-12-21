Feature: Comments

  Background: Url and Token
    * url apiUrl
    * def timeValidator = read ('classpath:helpers/timeValidator.js')
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def randomComment = dataGenerator.getRandomText()
    * def createCommentBody = {"comment": {"body": "#(randomComment)"}}

  Scenario: Post a comment for the first article and verify schema for all comments
    Given path 'articles'
    When method Get
    Then status 200
    * def firstArticleId = response.articles[0].slug

    Given path 'articles', firstArticleId, 'comments'
    When method Get
    Then status 200
    * def initialNumberOfComments = response.comments.length

    Given path 'articles', firstArticleId, 'comments'
    And request createCommentBody
    When method Post
    Then status 200

    Given path 'articles', firstArticleId, 'comments'
    When method Get
    Then status 200
    * def updatedNumberOfComments = response.comments.length
    And match response.comments == "#array"
    And match each response.comments ==
    """
    {
      "id": "#number",
        "createdAt": "#? timeValidator(_)",
        "updatedAt": "#? timeValidator(_)",
        "body": "#string",
        "author": {
            "username": "#string",
            "bio": "##string",
            "image": "#string",
            "following": "#boolean"
        }
    }
   """
    And match updatedNumberOfComments == initialNumberOfComments + 1

    * print firstArticleId
    * print initialNumberOfComments
    * print updatedNumberOfComments


