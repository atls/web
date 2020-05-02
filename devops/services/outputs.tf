output "youtrack_public_ip" {
  value = length(module.ecs_persisted_instance.public_ip) > 0 ? element(concat(module.ecs_persisted_instance.public_ip, list("")), 0) : ""
}

output "youtrack_private_key_path" {
  value = data.terraform_remote_state.infrastructure.ecs_instance_private_key_path
}
