resource "aws_s3_bucket" "remote_state" {
  bucket = "responsive-filemanager"
}


# PAID Service below
# resource "aws_dynamodb_table" "basicDBTable" {
#   name           = "terraform-remote-state"
#   hash_key       = "LockId"
#   billing_mode   = "PROVISIONED"
#   stream_enabled = true
#   read_capacity  = 1
#   write_capacity = 1

#   attribute {
#     name = "LockId"
#     type = "S"
#   }
# }