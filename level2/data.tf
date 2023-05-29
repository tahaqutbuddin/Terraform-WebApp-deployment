// It would fetch deployed architecture from level1 and then we'll use variables from there in our level2 files
data "terraform_remote_state" "level1" {
  backend = "s3"
  config = {
    bucket = "remote-state-taha"
    key    = "level1.tfstate"
    region = "us-east-1"
  }
}