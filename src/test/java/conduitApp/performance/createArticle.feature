Feature: Articles

  Background: Define URL and Token
    * url apiUrl
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def createArticleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
    * set createArticleRequestBody.article.title = __gatling.Title
    * set createArticleRequestBody.article.description = __gatling.Description
    * set createArticleRequestBody.article.body = dataGenerator.getRandomArticleValues().body

#    * def sleep = function(ms){ java.lang.Thread.sleep(ms) }
#    * def pause = karate.get('__gatling.pause', sleep)

  Scenario: Create and delete an article
    * configure headers = {"Authorization": #('Token ' + __gatling.token)}
    Given path 'articles'
    And request createArticleRequestBody
    And header karate-name = 'Create article'
    # And header karate-name = 'Title request: ' + __gatling.Title
    When method Post
    Then status 200
    * def articleId = response.article.slug
    
    # * karate.pause(5000)

    # Given path 'articles', articleId
    # When method Delete
    # Then status 204