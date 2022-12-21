function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }

  var config = {
    apiUrl: 'https://api.realworld.io/api/'
  }
  if (env == 'dev') {
    config.userEmail = 'iriska_dev@test.com'
    config.userPassword = 'iriska_dev@test.com'
  }
  if (env == 'qa') {
    config.userEmail = 'iriska_qa@test.com'
    config.userPassword = 'iriska_qa@test.com'
  }

  var accessToken = karate.callSingle('classpath:conduitApp/feature/CreateToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;
}