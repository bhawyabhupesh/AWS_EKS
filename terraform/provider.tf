provider "aws" {
  region  = "ap-south-1"
  version = ">= 2.38.0"
}



variable "cluster-name" {
  default = "terraform-eks-cluster"
  type    = string
}