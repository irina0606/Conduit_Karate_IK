Feature: Sign up a new user

  Background: Login

    * url apiUrl
    * def dataGenerator = Java.type('helpers.DataGenerator')
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUsername = dataGenerator.getRandomUsername()

  Scenario: Sign up
    Given path 'users'
    And request
    """
    {
        "user": {
            "email": "#(randomEmail)",
            "password": "Test@test",
            "username": "#(randomUsername)"
        }
    }
    """
    When method Post
    Then status 200
    And match response ==
    """
    {
        "user": {
            "email": "#(randomEmail)",
            "username": "#(randomUsername)",
            "bio": "##string",
            "image": "##string",
            "token": "#string"
        }
    }
    """

  Scenario Outline: Sign up with existing or missed data (negative scenario)
    Given path 'users'
    And request
    """
    {
        "user": {
            "email": "<email>",
            "password": "<password>",
            "username": "<username>"
        }
    }
"""
    When method Post
    Then status 422
    And match response == <errorResponse>

    Examples:
      | email            | password  | username            | errorResponse                                       |
      | #(randomEmail)   | Test@test | iriska              | {"errors":{"username":["has already been taken"]}}  |
      | iriska@test.com  | Test@test | #(randomUsername)   | {"errors":{"email":["has already been taken"]}}     |
      |                  | Test@test | #(randomUsername)   | {"errors":{"email":["can't be blank"]}}             |
      | iriska@test.com  |           | #(randomUsername)   | {"errors":{"password":["can't be blank"]}}          |
      | iriska@test.com  | Test@test |                     | {"errors":{"username":["can't be blank"]}}          |
