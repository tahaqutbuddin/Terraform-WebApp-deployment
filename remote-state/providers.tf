terraform {
  backend "s3" {
    bucket = "responsive-filemanager"
    key    = "remote-state.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

