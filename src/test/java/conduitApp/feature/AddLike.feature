Feature: Add like

  Background:
    * url apiUrl

Scenario: Add like

Given path 'articles', slug, 'favorite'
And request {}
When method Post
Then status 200
* def likeCount = response.article.favoritesCount
