resource "aws_route53_record" "alias" {
  zone_id = "${var.dns_zone_id}"
  name    = "${var.env}-${var.it_business_unit}-${var.it_root_functional_area}-${var.alb_name}-alb.${var.dns_zone_domain}"
  type    = "A"

  alias {
    name                   = "${aws_alb.alb.dns_name}"
    zone_id                = "${aws_alb.alb.zone_id}"
    evaluate_target_health = "true" // cannot evaluate target if internal
  }

  count = "${var.dns_zone_id != "" ? 1:0}"
}