resource "aws_security_group" "cache" {
  name = "tf-cd-cache01"
  description = "Allow traffic to ElastiCache cache01"
  vpc_id = "${data.aws_vpc.vpc.id}"

  tags {
    Name = "tf-cd-cache01"
    "cost:project" = "cd"
  }
}

resource "aws_security_group_rule" "allow_ecs_to_cache" {
  security_group_id = "${aws_security_group.cache.id}"
  type = "ingress"
  from_port = 6379
  to_port = 6379
  protocol = "tcp"
  source_security_group_id = "${data.terraform_remote_state.shared.ecs_cluster_security_group_id}"
}

resource "aws_security_group_rule" "allow_all_from_cache" {
  security_group_id = "${aws_security_group.cache.id}"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
