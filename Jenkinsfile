pipeline {
	agent any

	stages {

		//stage('Scanning Sonar'){
		//	steps {
		//		sh '''
		//		cd Solution
		//		chmod +x ./script-sonarscanner.sh
		//		sudo ./script-sonarscanner.sh
		//		cd ..
		//		'''
		//	}
		//}

		stage('git pull'){
			steps {
				sh '''
                git pull
				'''
			}
		}
        stage('artisan runner'){
			steps {
				sh '''
                php artisan migrate
                php artisan optimize:clear
         		'''
			}
		}

        stage('composer runner'){
			steps {
				sh '''
				docker compose down
                docker compose up -d
				'''
			}
		}
	}
	post {
		always {
			echo 'This will always run'
		}
		success {
			echo 'This will run only if successful'
		}
		failure {
			mail bcc: '',
			body: "<b>Example</b><br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}",
			cc: '', charset: 'UTF-8',
			from: '', mimeType: 'text/html',
			replyTo: '',
			subject: "ERROR CI: Project name -> ${env.JOB_NAME}",
			to: "hendry.priyatno@mitrasolutech.com";
		}
		unstable {
			echo 'This will run only if the run was marked as unstable'
		}
		changed {
			echo 'This will run only if the state of the Pipeline has changed'
			echo 'For example, if the Pipeline was previously failing but is now successful'
		}
	}
}
