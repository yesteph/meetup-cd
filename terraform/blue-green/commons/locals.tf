locals {
  // ensure variable deployment_step is correctly formatted
  deployment_step            = "${var.deployment_step}"
  blue_lb_dns                = "${data.consul_keys.blue_components.var.blue_env == "a" ? module.public_alb_a.dns_name : module.public_alb_b.dns_name}"
  green_lb_dns               = "${data.consul_keys.blue_components.var.blue_env == "a" ? module.public_alb_b.dns_name : module.public_alb_a.dns_name}"
  blue_lb_dns_zone_id        = "${data.consul_keys.blue_components.var.blue_env == "a" ? module.public_alb_a.dns_alb_zone_id : module.public_alb_b.dns_alb_zone_id}"
  green_lb_dns_zone_id       = "${data.consul_keys.blue_components.var.blue_env == "a" ? module.public_alb_b.dns_alb_zone_id : module.public_alb_a.dns_alb_zone_id}"
  not_current_blue_env       = "${data.consul_keys.blue_components.var.blue_env == "a" ? "b":"a"}"
  blue_components_for_consul = "${local.deployment_step != "finalize_deployment" ? data.consul_keys.blue_components.var.blue_env : local.not_current_blue_env}"
  active_lb_dns              = "${local.deployment_step == "promote_green" || local.deployment_step == "finalize_deployment" ? local.green_lb_dns:local.blue_lb_dns }"
  active_lb_dns_zone_id      = "${local.deployment_step == "promote_green" || local.deployment_step == "finalize_deployment" ? local.green_lb_dns_zone_id:local.blue_lb_dns_zone_id }"

  // finalize_deployment et current blue is a || rollback et current blue is not a => a=0 et LB => null -> deletion et DRAINING ?
  blue_lb_dns_for_consul = "${local.deployment_step == "finalize_deployment" ? local.green_lb_dns : local.blue_lb_dns}"

  // B/G current steps
  creating_green_b  = "${local.deployment_step == "create_green" && data.consul_keys.blue_components.var.blue_env == "a"}"
  promoting_green_a = "${local.deployment_step == "promote_green" && data.consul_keys.blue_components.var.blue_env == "b"}"
  finalizing_a      = "${local.deployment_step == "finalize_deployment" && data.consul_keys.blue_components.var.blue_env == "b"}"
  deploy_blue_a     = "${local.deployment_step == "deploy_blue" && data.consul_keys.blue_components.var.blue_env == "a"}"

}
