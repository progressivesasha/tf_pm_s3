resource "aws_security_group" "puppetserver" {
	name		  		= "${var.puppetsg_name}"
	depends_on 	  = ["aws_default_vpc.default"]
	vpc_id 		  	= "${aws_default_vpc.default.id}"
	description   = "Allow egress and ssh/puppet traffic"
	ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["89.162.139.0/24"]
	}
	ingress {
		from_port   = 8140
		to_port     = 8140
		protocol    = "tcp"
		cidr_blocks = ["${aws_default_vpc.default.cidr_block}"]
	}
	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["${aws_default_vpc.default.cidr_block}"]
	}
	ingress {
		from_port   = 80
		to_port     = 80
		protocol    = "tcp"
		cidr_blocks = ["${aws_default_vpc.default.cidr_block}"]
	}
  ingress {
		from_port   = 443
		to_port     = 443
		protocol    = "tcp"
		cidr_blocks = ["${aws_default_vpc.default.cidr_block}"]
	}
}

resource "aws_instance" "puppetserver" {
	depends_on             = ["aws_security_group.puppetserver"]
	count                  = 1
	key_name               = "${var.key_name}"
	ami                    = "${data.aws_ami.centos7.id}"
	instance_type          = "${var.instance_type}"
	user_data              = "${data.template_file.puppetserver_config.rendered}"
	security_groups        = ["${aws_security_group.puppetserver.name}"]
  iam_instance_profile   = "${aws_iam_instance_profile.instance_profile.name}"
	tags {
		Name = "puppet"
	}
}
