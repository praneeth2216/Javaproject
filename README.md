# java-eks-app

Sample Spring Boot Java app with Jenkins pipeline to build image, push to ECR and deploy to EKS.

## Quick setup

1. Replace `<AWS_ACCOUNT_ID>` and `<REGION>` placeholders in `Jenkinsfile` and `k8s/deployment.yaml`.
2. Create an ECR repo:
   ```bash
   aws ecr create-repository --repository-name java-eks-app --region <REGION>
   ```
3. Push this repo to GitHub and configure Jenkins job (Pipeline) to point to the repo.
4. Ensure Jenkins agents have:
   - Docker (or Kaniko) to build images,
   - `aws` CLI configured (or use IAM role/IRSA),
   - `kubectl` access to the target EKS cluster (kubeconfig or in-cluster service account).
5. Run pipeline. The app exposes `/hello` on port 8080.

## Files
- `Jenkinsfile` - Declarative pipeline
- `Dockerfile` - Multi-stage build
- `k8s/deployment.yaml` - Kubernetes Deployment (replace image)
- `k8s/service.yaml` - Kubernetes Service (LoadBalancer)
