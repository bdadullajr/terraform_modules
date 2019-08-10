#----storage/outputs.tf----
output "bucketname" {
  value = "${aws_s3_bucket.iac_code.id}"
}
