
Feature: Articles

  Background: Define URL and Token
    * url apiUrl
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def createArticleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
    * set createArticleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
    * set createArticleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
    * set createArticleRequestBody.article.body = dataGenerator.getRandomArticleValues().body
    * def favoriteArticleBody = {}

  Scenario: Create and delete an article
    Given path 'articles'
    And request createArticleRequestBody
    When method Post
    Then status 200
    And match response.article.title == createArticleRequestBody.article.title
    And match response.article.description == createArticleRequestBody.article.description
    And match response.article.body == createArticleRequestBody.article.body
    * def articleId = response.article.slug

    Given params { limit: 10, offset: 0 }
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title == createArticleRequestBody.article.title

    Given path 'articles', articleId
    When method Delete
    Then status 204

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get
    Then status 200
    And match response.articles[0].title != createArticleRequestBody.article.title

  Scenario: Get articles of your feed
    Given path 'articles/feed'
    When method Get
    Then status 200
    * def articleTotalAmount = response.articlesCount
    * assert articleTotalAmount == 0
    Then print articleTotalAmount

  Scenario: Get articles of the global feed
    Given path 'articles'
    When method Get
    Then status 200
    * def articleTotalAmount = response.articlesCount
    * assert articleTotalAmount != 0
    Then print articleTotalAmount

  Scenario: Get the favorites count and slug ID for the first article, save it to variables
    Given path 'articles'
    When method Get
    Then status 200
    * def firstArticle = response. articles[0]
    * def firstArticleId = response.articles[0].slug
    * def firstArticleFavoritesCount = response.articles[0].favoritesCount
    * print firstArticle
    * print firstArticleId
    * print firstArticleFavoritesCount

  Scenario: Get the article by ID
    * def articleId = 'Virtual-maximized-capacity-117728'
    Given path 'articles', articleId
    When method Get
    Then status 200
    * print response

  Scenario: Favorite/ Unfavorite the first article
    Given path 'articles'
    When method Get
    Then status 200
    * def firstArticleId = response.articles[0].slug
    * def favoritesCount = response.articles[0].favoritesCount
    * def firstArticle = response.articles[0]

    * if (favoritesCount == 0) karate.call('classpath:conduitApp/feature/AddLike.feature', firstArticle)

    Given path "articles"
    When method Get
    Then status 200
    And match response.articles[0].favoritesCount == 1
    * def increasedCount = response.articles[0].favoritesCount

    Given path 'articles', firstArticleId, 'favorite'
    When method Delete
    Then status 200
    * def decreasedCount = response.article.favoritesCount
    And match decreasedCount == 0

    * print firstArticleId
    * print favoritesCount
    * print increasedCount
    * print decreasedCount

#  Scenario: Get all favorite articles
#    Given path 'articles'
#    When method Get
#    Then status 200





