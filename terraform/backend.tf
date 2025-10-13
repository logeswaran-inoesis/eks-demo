terraform {
  backend "s3" {
    bucket         = "demo-eks-terraform-state-loges-2026"
    key            = "eks/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    # use_lockfile = true  # optional, Terraform will handle simple locking
  }

}
