output "VPC ID" {
  value = "${aws_vpc.main.id}"
}

output "Public Subnet ID" {
  value = "${aws_subnet.public.id}"
}

output "Private Subnet ID" {
  value = "${aws_subnet.private.id}"
}

output "NAT Elastic IP" {
  value = "${aws_eip.ngw_elastic_ip.public_ip}"
}

output "elb_dns_name" {
  value = "${aws_elb.example.dns_name}"
}
