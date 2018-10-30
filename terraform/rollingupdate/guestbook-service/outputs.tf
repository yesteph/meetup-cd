output "primary_endpoint_address" {
  value = "${local.cache_primary_endpoint_address}"
}


output "endpoint" {
  value = "${data.terraform_remote_state.commons.endpoint}"
}

output "default_target_group_arn" {
  value = "${data.terraform_remote_state.commons.default_target_group_arn}"
}