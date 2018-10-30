output "default_target_group_arn-a" {
  value = "${module.alb-a.default_target_group_arn}"
}

output "endpoint-a" {
  value = "${module.alb-a.dns_alias}"
}

output "default_target_group_arn-b" {
  value = "${module.alb-b.default_target_group_arn}"
}

output "endpoint-b" {
  value = "${module.alb-b.dns_alias}"
}