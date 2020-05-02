module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 1.0"

  name = "aunited-vpc"

  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  assign_generated_ipv6_cidr_block = true

  enable_nat_gateway = true
  single_nat_gateway = true
}

resource "aws_iam_role" "ecs_host_role" {
  name               = "aunited_ecs_host_role"
  assume_role_policy = "${file("./policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "aunited_ecs_instance_role_policy"
  policy = "${file("./policies/ecs-instance-role-policy.json")}"
  role   = "${aws_iam_role.ecs_host_role.id}"
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "aunited_ecs_service_role"
  assume_role_policy = "${file("./policies/ecs-role.json")}"
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "aunited_ecs_service_role_policy"
  policy = "${file("./policies/ecs-service-role-policy.json")}"
  role   = "${aws_iam_role.ecs_service_role.id}"
}

resource "aws_iam_instance_profile" "ecs" {
  name = "aunited_ecs_instance_profile"
  role = "${aws_iam_role.ecs_host_role.name}"
  path = "/"

  provisioner "local-exec" {
    command = "sleep 60"
  }
}

resource "aws_ecs_cluster" "aunited" {
  name = "aunited"
}

resource "aws_cloudwatch_log_group" "system" {
  name = "system"
}

resource "aws_key_pair" "ecs" {
  key_name   = "ecs-key"
  public_key = "${file("./keys/aunited-ecs.pub")}"
}
