  variable "region" {
    type        = string
    default     = "ap-south-1"
    description = "aws description"
  }
  variable "cidr_block" {
    type    = string
    default = "10.10.0.0/16"
  }
  variable "tags" {
    type = map(string)
    default = {
      terraform  = "true"
      kubernetes = "demo_esk_cluster"
      Name       = "demo-vpc"
    }
    description = "tags for aws resources"
  }

  variable "eks_version" {
  type = string
  default = "1.31"
  description = "EKS version"
  }

  variable "cluster_name" {
  type = string
  default = "demo-eks-cluster"
  description = "value of the EKS cluster name"
    
  }