pipeline {
  agent any

  environment {
    PATH = '/usr/local/rvm/bin:/usr/bin:/bin'
    RUBY_VERSION = '2.4.4'
  }

  options {
    disableConcurrentBuilds()
  }

  parameters {
    string(name: 'DENEBOLA_VERSION', defaultValue: '', description: 'デプロイするバージョン')
    string(name: 'SUBRA_BRANCH', defaultValue: 'master', description: 'Chefのブランチ')
    choice(name: 'SCOPE', choices: 'full\napp', description: 'デプロイ範囲')
    booleanParam(name: 'ModuleTest', defaultValue: true, description: 'Module Testを実行するかどうか')
    booleanParam(name: 'Deploy', defaultValue: true, description: 'Deployを実行するかどうか')
  }

  stages {
    stage('Test Setting') {
      when {
        expression {
          return env.ENVIRONMENT == 'development' && params.ModuleTest
        }
      }

      steps {
        script {
          sh "rvm ${RUBY_VERSION} do bundle install --path=vendor/bundle"
          sh "sudo mkdir log"
          sh "rvm ${RUBY_VERSION} do env RAILS_ENV=test bundle exec rake db:reset"
          sh "rvm ${RUBY_VERSION} do env RAILS_ENV=test bundle exec rake db:migrate"
        }
      }
    }

    stage('Module Test') {
      when {
        expression { return env.ENVIRONMENT == 'development' && params.ModuleTest }
      }

      steps {
        sh "rvm ${RUBY_VERSION} do bundle exec rspec spec/{models,libs,aggregation.rb}"
      }
    }

    stage('Deploy') {
      steps {
        ws("${env.WORKSPACE}/../chef") {
          script {
            git url: 'https://github.com/Leonis0813/subra.git', branch: params.SUBRA_BRANCH

            def version = params.DENEBOLA_VERSION.replaceFirst(/^.+\//, '')
            def recipe = ('app' == params.SCOPE ? 'app' : 'default')
            sh "sudo DENEBOLA_VERSION=${version} chef-client -z -r denebola::${recipe} -E ${env.ENVIRONMENT}"
          }
        }
      }
    }
  }
}
