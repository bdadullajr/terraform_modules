#----root/outputs.tf-----

#----storage outputs------
output "Bucket Name" {
  value = "${module.storage.bucketname}"
}

#-----networking/outputs.tf----

output "public_subnets" {
  #value = "${aws_subnet.iac_public_subnet.*.id}"
  value = "${aws_subnet.iac_public_subnet.id}"
}

output "public_sg" {
  value = "${aws_security_group.iac_public_sg.id}"
}

output "subnet_ips" {
  value = "${aws_subnet.iac_public_subnet.cidr_block}"
}

