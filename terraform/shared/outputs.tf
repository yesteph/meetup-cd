output "external_ecs_access_security_group_id"{
  value = "${module.asg.external_ecs_access_security_group_id}"
}

output "ecs_cluster_security_group_id" {
  value = "${module.asg.ecs_cluster_security_group_id}"
}