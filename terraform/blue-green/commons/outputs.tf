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

output "service-endpoint" {
  value = "${aws_route53_record.public_dns_alias.fqdn}"
}

output "green-service-endpoint" {
  value = "${aws_route53_record.public_green_dns_alias.fqdn}"
}

output "green_env" {
  value = "${local.not_current_blue_env}"
}