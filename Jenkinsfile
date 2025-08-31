pipeline {
  agent any
  environment {
    AWS_REGION = "us-east-1"
    AWS_ACCOUNT_ID = "279427096273"
    ECR_REGISTRY = "279427096273.dkr.ecr.us-east-1.amazonaws.com/java-eks-app"
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
