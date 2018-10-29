resource "aws_elasticache_subnet_group" "cache" {
  name = "tf-${terraform.workspace}-cd-cache01"
  subnet_ids = ["${data.aws_subnet_ids.subnets.ids}"]
}

resource "aws_elasticache_replication_group" "cache" {
  replication_group_id = "${local.replication_group_id}"
  replication_group_description = "tf-${terraform.workspace}-cd-cache01"
  engine_version = "3.2.10"
  node_type = "cache.t2.small"
  number_cache_clusters = "1"
  port = "6379"
  parameter_group_name = "default.redis3.2"
  automatic_failover_enabled = "false"
  subnet_group_name= "${aws_elasticache_subnet_group.cache.name}"
  security_group_ids = ["${aws_security_group.cache.id}"]
  //notification_topic_arn = "${var.sns_alerting_arn}"
  maintenance_window = "sun:02:00-sun:04:00"
  auto_minor_version_upgrade = "false"
  apply_immediately = "true"

  tags {
    "cost:project" = "cd",
    "cost:cost-center" = "${terraform.workspace == "prod"?"prod":"dev"}",
    "cost:environment" = "${terraform.workspace}",
    "cost:component" = "elasticache",
  }
  count = "${terraform.workspace == "prod" ? 0 : 1}"
}
