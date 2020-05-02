output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "private_subnets_cidr_blocks" {
  value = "${module.vpc.private_subnets_cidr_blocks}"
}

output "public_subnets_cidr_blocks" {
  value = "${module.vpc.public_subnets_cidr_blocks}"
}

output "ecs_aws_iam_instance_profile" {
  value = "${aws_iam_instance_profile.ecs.name}"
}

output "ecs_iam_role" {
  value = "${aws_iam_role.ecs_service_role.arn}"
}

output "system_aws_cloudwatch_log_group" {
  value = "${aws_cloudwatch_log_group.system.name}"
}

output "ecs_cluster" {
  value = "${aws_ecs_cluster.aunited.id}"
}

output "ecs_instance_private_key_path" {
  value = "${path.cwd}/keys/aunited-ecs"
}

output "ecs_key_pair_name" {
  value = "${aws_key_pair.ecs.key_name}"
}
