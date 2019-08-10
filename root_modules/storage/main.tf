#---------storage/main.tf---------

# Create a random id
resource "random_id" "iac_bucket_id" {
  byte_length = 2
}

# Create the bucket
resource "aws_s3_bucket" "iac_code" {
    bucket        = "${var.project_name}-${random_id.iac_bucket_id.dec}"
    acl           = "private"

    force_destroy =  true

    tags {
      Name = "iac_bucket"
    }
}
