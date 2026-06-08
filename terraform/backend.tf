terraform {
  backend "s3" {
    bucket = "statefile-bucket-2026"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "statefile-table"
    encrypt = true
  }
}
