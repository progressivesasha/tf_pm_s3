resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.pmnamepref}_profile"
  role = "${aws_iam_role.instance_role.name}"
}

resource "aws_iam_role" "instance_role" {
  name = "${var.pmnamepref}_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "AllowEC2AccessToS3"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "${var.pmnamepref}_s3_access"
  role = "${aws_iam_role.instance_role.id}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "s3:*"
      ],
      "Resource" : ["arn:aws:s3:::${var.bucket_name}", "arn:aws:s3:::${var.bucket_name}/*"]
    }
  ]
}
EOF
}
