terraform {
  backend "s3" {
    bucket         = "terraform-state-commit-eks"
    key            = "kubernetes/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true                    # Encrypt the state file at rest
  }
}
  
provider "kubernetes" {
  config_path = "~/.kube/config"
}
