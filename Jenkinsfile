pipeline {
  agent any
  environment {
    AWS_REGION = "<REGION>"
    AWS_ACCOUNT_ID = "<AWS_ACCOUNT_ID>"
    ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    IMAGE_NAME = "java-eks-app"
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build JAR') {
      steps {
        sh 'mvn -B -DskipTests package'
      }
    }
    stage('Docker Build & Push') {
      steps {
        sh '''
          aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
          docker build -t $IMAGE_NAME:$BUILD_NUMBER .
          docker tag $IMAGE_NAME:$BUILD_NUMBER $ECR_REGISTRY/$IMAGE_NAME:$BUILD_NUMBER
          docker push $ECR_REGISTRY/$IMAGE_NAME:$BUILD_NUMBER
          docker tag $IMAGE_NAME:$BUILD_NUMBER $ECR_REGISTRY/$IMAGE_NAME:latest
          docker push $ECR_REGISTRY/$IMAGE_NAME:latest
        '''
      }
    }
    stage('Deploy to EKS') {
      steps {
        sh '''
          kubectl set image deployment/java-eks-app java-eks-app=$ECR_REGISTRY/$IMAGE_NAME:$BUILD_NUMBER --record
          kubectl rollout status deployment/java-eks-app
        '''
      }
    }
  }
}
