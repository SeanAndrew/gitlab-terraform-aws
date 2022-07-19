terraform {
  required_version = ">= 0.12.31"
  backend "s3" {
    bucket         = "tf-{aws-account-id}-devops-state"
    key            = "gitlab/poc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-{aws-account-id}-devops-state"
  }
}