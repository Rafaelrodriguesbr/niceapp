
#### Creating Launch Configuration ####
resource "aws_launch_configuration" "launch_configuration" {
  image_id               = "${var.ami}"
  instance_type          = "${var.instance_type}"
  security_groups        = ["${aws_security_group.sg.name}"]
  key_name               = "${aws_key_pair.ssh.key_name}"
  user_data =           "${data.template_file.bootstrap_ec2.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.instance-profile.name}"

  lifecycle {
    create_before_destroy = true
  }
}

####Creating AutoScaling Group - WEB ####
resource "aws_autoscaling_group" "autoscaling" {
  launch_configuration = "${aws_launch_configuration.launch_configuration.id}"
  availability_zones = "${var.azs}"
  min_size = 2
  max_size = 3
  load_balancers = ["${aws_elb.elb-web.name}"]
  health_check_type = "ELB"
  tag {
    key = "Name"
    value = "niceapp-asg-web"
    propagate_at_launch = true
  }
}

#### Creating ELB - WEB ####
resource "aws_elb" "elb-web" {
  name = "niceapp-asg-web"
  security_groups = ["${aws_security_group.sg.id}"]
  availability_zones = "${var.azs}"
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:8080/"
  }
  listener {
    lb_port = 8080
    lb_protocol = "http"
    instance_port = 8080
    instance_protocol = "http"
  }
   listener {
    lb_port = 5000
    lb_protocol = "http"
    instance_port = 5000
    instance_protocol = "http"
  }
    tags = {
    Name = "web-niceapp-elb"
  }
}

#### Security Group port 8080,5000,22 ####
	resource "aws_security_group" "sg" {
    name = "security_group_for_niceapp"
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = "${var.ip_ssh}"
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
        create_before_destroy = true
    }
}




