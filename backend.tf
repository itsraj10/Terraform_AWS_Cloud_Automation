terraform {
  backend "s3" {
    bucket         = "terraformbucketstatefile942464" # change this
    key            = "env/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
