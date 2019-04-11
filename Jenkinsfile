pipeline {
  agent any

  options {
    disableConcurrentBuilds()
  }

  parameters {
    string(name: 'DENEBOLA_VERSION', defaultValue: '', description: 'デプロイするバージョン')
    string(name: 'SUBRA_BRANCH', defaultValue: 'master', description: 'Chefのブランチ')
    choice(name: 'SCOPE', choices: 'app\nfull', description: 'デプロイ範囲')
  }

  stages {
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
