provider "aws" {
  profile = "default"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_acc_id}:role/terraform-test-role"
  }
}

data "aws_ami" "centos7" {
	most_recent = true
	filter {
		name   = "name"
		values = ["RHEL-7.3_HVM-20170613-x86_64*"]
	}
	filter {
		name   = "virtualization-type"
		values = ["hvm"]
	}
}

resource "aws_default_vpc" "default" {
	tags {
		Name = "DefaultVPC"
	}
}

data "template_file" "puppetserver_config" {
	template = "${file("${path.module}/configs/puppetserver_config.tpl")}"
  vars {
    bucket_name = "${var.bucket_name}"
    git_username = "${var.git_username}"
  }
}
