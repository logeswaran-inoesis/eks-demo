# EKS Terraform Demo

Deploy an **Amazon EKS cluster** and your application using Terraform and CI/CD.

---

## Quick Start

### 1. Clone the Repository

```bash
1.git clone https://github.com/logeswaran-inoesis/eks-demo.git
cd terraform


2. Initialize Terraform
terraform init

3. Review the Plan
terraform plan

4. Apply Terraform Configuration
terraform apply


This will create: VPC, subnets, NAT gateway, EKS cluster, and node groups.

5. Update kubeconfig
aws eks update-kubeconfig --region ap-south-1 --name demo-eks-cluster


Replace region or cluster name if different.

6. Trigger CI/CD Pipeline

Open your GitHub Actions workflow (or Jenkins pipeline).

Click Run workflow.

The application will be deployed automatically to your EKS cluster.

Notes

Terraform state is stored in S3: demo-eks-terraform-state-loges-2025.

Update eks_version in variables.tf to upgrade Kubernetes.

Quick Commands Summary
git clone https://github.com/logeswaran-inoesis/eks-demo.git
cd terraform
terraform init
terraform plan
terraform apply
aws eks update-kubeconfig --region ap-south-1 --name demo-eks-cluster
# Trigger CI/CD workflow
