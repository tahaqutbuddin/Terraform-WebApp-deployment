terraform {
  backend "s3" {
    bucket = "remote-state-taha"
    key    = "level0.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}



