🚀 URL Shortener SaaS - Multi-Environment EKS Project
This project demonstrates a production-ready deployment of a URL Shortener application (Python/Flask) on AWS. It features a fully automated CI/CD pipeline, infrastructure as code (IaC), and multi-environment management using Kubernetes (EKS).

🏗 System Architecture
The infrastructure is built using a modular approach with high isolation:

- Networking: Dedicated VPCs for each environment, including Public/Private subnets and NAT Gateways.

- Compute: Amazon EKS clusters with Managed Node Groups.

- CI/CD: Automated pipelines via GitHub Actions using OIDC for secure, keyless authentication.

- Registry: Amazon ECR for high-availability Docker image storage.

🛠 Tech Stack
- Infrastructure: Terraform (Workspaces: stage, prod).

- Orchestration: Kubernetes (EKS), Helm.

- Cloud: AWS (VPC, ECR, EKS, IAM, OIDC).

- CI/CD: GitHub Actions.

- Security: IAM Role-based access (OIDC), EKS Access Entries (EKS API security).

🔧 Challenges & Solutions (The DevOps Journey)
During development, we tackled several complex DevOps hurdles:

1. Multi-Workspace OIDC Strategy: We designed the IAM Role and OIDC Provider to be global resources (created in stage) but accessible to all environments via Data Sources. This prevented "Resource Already Exists" errors during the production rollout.

2. IP Address Optimization: Solved AddressLimitExceeded errors by optimizing NAT Gateway usage (implementing single_nat_gateway = true for specific environments).

3. Secure EKS Access: Configured aws_eks_access_entry to allow the GitHub runner to execute kubectl and helm commands securely within the private cluster.

🚀 Usage & Operations
Testing Local Connectivity (Port-Forward)
To verify the application is running inside the cluster without public exposure:
```bash
kubectl port-forward deployment/staging-app 8080:8080 -n staging
```
API Interaction (CURL)
Once the port is open, you can test the logic:
```js
- GET Request: curl -X GET http://localhost:8080/health
- POST Request (Shorten URL):
curl -X POST http://localhost:8080/shorten \
     -H "Content-Type: application/json" \
     -d '{"url": "https://www.google.com"}'
```

Environment Management
Switching between environments is handled via Terraform Workspaces:
```bash
terraform workspace select stage  # Switch to Staging
terraform workspace select prod   # Switch to Production
```
🚢 CI/CD Pipeline Flow
- Branch Push (Non-main): Triggers testing, provisions/updates the stage workspace, and deploys to the Staging cluster.

- Merge to Main: Triggers the Production pipeline, switches the workspace to prod, and performs a full deployment to the Production cluster.

📝 Roadmap & Future Enhancements
[ ] Implement permanent custom domains via Route53 and ExternalDNS.

[ ] Configure SSL/TLS termination using AWS Certificate Manager.

[ ] Deploy a full Monitoring stack (Prometheus & Grafana).

[ ] Configure HPA (Horizontal Pod Autoscaler) for dynamic scaling.