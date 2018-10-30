module "alb-a" {
  source = "../modules/terraform-alb-module"

  aws_region = "${var.aws_region}"
  env = "${terraform.workspace}"
  vpc_id = "${data.aws_vpc.vpc.id}"
  internal = "false"
  it_business_unit = "cd"
  it_root_functional_area = "front"
  subnet_ids = "${data.aws_subnet_ids.subnets.ids}"
  alb_name = "public-a"
  health_check_path = "/"
  dns_zone_id = "${data.aws_route53_zone.public_zone.zone_id}"
  dns_zone_domain = "${data.aws_route53_zone.public_zone.name}"
  additional_security_groups_to_add = ["${data.terraform_remote_state.shared.external_ecs_access_security_group_id}"]
}

module "alb-b" {
  source = "../modules/terraform-alb-module"

  aws_region = "${var.aws_region}"
  env = "${terraform.workspace}"
  vpc_id = "${data.aws_vpc.vpc.id}"
  internal = "false"
  it_business_unit = "cd"
  it_root_functional_area = "front"
  subnet_ids = "${data.aws_subnet_ids.subnets.ids}"
  alb_name = "public-b"
  health_check_path = "/"
  dns_zone_id = "${data.aws_route53_zone.public_zone.zone_id}"
  dns_zone_domain = "${data.aws_route53_zone.public_zone.name}"
  additional_security_groups_to_add = ["${data.terraform_remote_state.shared.external_ecs_access_security_group_id}"]
}

locals {
  env                   = "${terraform.workspace}"
  customer_care_domain  = "${data.terraform_remote_state.shared.additional_dns_zone_domains[0]}"
  nb_additional_domains = "${length(data.terraform_remote_state.shared.additional_dns_zone_domains)}"

  // hack to make terraform crash if more than one additional_domain_name
  check_only_one_additional_dns_zone_domain = "${local.nb_additional_domains == 1 ? data.terraform_remote_state.shared.additional_dns_zone_domains[0] : element(data.terraform_remote_state.shared.additional_dns_zone_domains, local.nb_additional_domains + 1) }"

  // on prod: set dns alias on root domain level
  public_dns_alias_name       = "${local.env == "prod" ? data.aws_route53_zone.customer_care.name : format("%s.%s", local.env, data.aws_route53_zone.customer_care.name)}"
  public_green_dns_alias_name = "${format("green-%s.%s", local.env, data.aws_route53_zone.customer_care.name)}"
}

resource "aws_route53_record" "public_dns_alias" {
  zone_id = "${data.aws_route53_zone.customer_care.zone_id}"
  name    = "${local.public_dns_alias_name}"
  type    = "A"

  alias {
    name                   = "${local.active_lb_dns}"
    zone_id                = "${local.active_lb_dns_zone_id}"
    evaluate_target_health = true                             // cannot evaluate target if internal
  }
}

resource "aws_route53_record" "public_green_dns_alias" {
  count   = "${local.blue_green_enabled == "true" ? 1 : 0}"
  zone_id = "${data.aws_route53_zone.customer_care.zone_id}"
  name    = "${local.public_green_dns_alias_name}"
  type    = "A"

  alias {
    name                   = "${local.green_lb_dns}"
    zone_id                = "${local.green_lb_dns_zone_id}"
    evaluate_target_health = true                            // cannot evaluate target if internal
  }
}