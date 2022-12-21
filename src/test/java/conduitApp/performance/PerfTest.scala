package conduitApp.performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef.{nothingFor, _}
import conduitApp.performance.createTokens.CreateTokens

class PerfTest extends Simulation {

  CreateTokens.createAccessTokens()

  val protocol = karateProtocol(
    "/api/articles/{articleId}" -> Nil
  )

 protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")

  val csvFeeder =  csv("articles.csv").circular
  var tokenFeeder = Iterator.continually(Map("token" -> CreateTokens.getNextToken))

  val createArticle = scenario("Create and delete an article")
      .feed(csvFeeder)
      .feed(tokenFeeder)
      .exec(karateFeature("classpath:conduitApp/performance/createArticle.feature"))


  setUp(
    createArticle.inject(
          atOnceUsers(1),
          nothingFor(4),
          constantUsersPerSec(1).during(10),
          // constantUsersPerSec(2).during(10),
          // rampUsersPerSec(2).to(10).during(20),
          // nothingFor(4),
          // constantUsersPerSec(1).during(10)
    ).protocols(protocol)
  )

}