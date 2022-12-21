Feature: work with DB

  Background: connect to db
    * def dbHandler = Java.type('helpers.DbHandler')

  Scenario: Seed db with a new job
    * eval dbHandler.addNewJobWithName("QA5")

#  Scenario: Get level for Job
#    * def level = dbHandler.getMinAndMaxLevelsForJob("Publisher")
#    * print level.minLvl
#    * print level.maxLvl
#    And match level.minLvl == '80'
#    And match level.maxLvl == '120'


