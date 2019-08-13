resource "aws_launch_configuration" "asg-launchconfig" {
  name_prefix     = "asg-launchconfig"
  image_id        = "${lookup(var.amis,var.region)}"
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.web-ec2-key.key_name}"
  security_groups = ["${aws_security_group.allow-ssh.id}"]

  user_data = <<EOF
#!/bin/bash
sudo yum install httpd -y
sudo cd /var/www/html
sudo echo "Hello World" > index.html
sudo chkconfig httpd on
sudo service httpd start
EOF
}

resource "aws_autoscaling_group" "asg-autoscaling" {
  name                      = "asg-autoscaling"
  vpc_zone_identifier       = ["${aws_subnet.public.id}"]
  launch_configuration      = "${aws_launch_configuration.asg-launchconfig.name}"
  load_balancers            = ["${aws_elb.example.name}"]
  min_size                  = 1
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ASG Instance"
    propagate_at_launch = true
  }
}
