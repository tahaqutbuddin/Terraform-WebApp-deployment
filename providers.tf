terraform {
  backend "s3" {
    bucket = "responsive-filemanager"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region = "us-east-1"
}

