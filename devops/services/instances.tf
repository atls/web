resource "aws_security_group" "ecs_lb" {
  name   = "ecs-lb"
  vpc_id = "${data.terraform_remote_state.infrastructure.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_instance" {
  name   = "ecs-instance"
  vpc_id = "${data.terraform_remote_state.infrastructure.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.ecs_lb.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-*.*.i-amazon-ecs-optimized",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }

  owners = ["amazon"]
}

module "ecs_persisted_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 1.0"

  name           = "ecs-persisted"
  instance_count = 1

  instance_type               = "t2.medium"
  key_name                    = "${data.terraform_remote_state.infrastructure.ecs_key_pair_name}"
  monitoring                  = true
  associate_public_ip_address = true

  ami                    = "${data.aws_ami.amazon_linux.id}"
  vpc_security_group_ids = ["${aws_security_group.ecs_instance.id}"]
  subnet_id              = "${element(data.terraform_remote_state.infrastructure.public_subnets, 0)}"
  iam_instance_profile   = "${data.terraform_remote_state.infrastructure.ecs_aws_iam_instance_profile}"

  user_data = "#!/bin/bash\necho ECS_CLUSTER='aunited' > /etc/ecs/ecs.config"
}
