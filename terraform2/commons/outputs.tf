output "default_target_group_arn" {
  value = "${module.alb.default_target_group_arn}"
}

output "endpoint" {
  value = "${module.alb.dns_alias}"
}