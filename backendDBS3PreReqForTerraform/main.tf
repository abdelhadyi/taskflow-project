resource "aws_s3_bucket" "statefile-s3" {
  bucket = "statefile-bucket-2026"
}

resource "aws_dynamodb_table" "statefile-dynamodb" {
  name           = "statefile-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
