module "alb" {
  source = "../modules/terraform-alb-module"

  aws_region = "${var.aws_region}"
  env = "${terraform.workspace}"
  vpc_id = "${data.aws_vpc.vpc.id}"
  internal = "false"
  it_business_unit = "cd"
  it_root_functional_area = "front"
  subnet_ids = "${data.aws_subnet_ids.subnets.ids}"
  alb_name = "public"
  health_check_path = "/"
  dns_zone_id = "${data.aws_route53_zone.public_zone.zone_id}"
  dns_zone_domain = "${data.aws_route53_zone.public_zone.name}"
  additional_security_groups_to_add = ["${data.terraform_remote_state.shared.external_ecs_access_security_group_id}"]
}