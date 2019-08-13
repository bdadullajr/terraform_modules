resource "aws_key_pair" "web-ec2-key" {
  key_name   = "web-key"
  public_key = "${file("~/.ssh/app-ec2-key.pub")}"
}
