locals{
  replication_group_id = "tf-cd-cache01"
  cache_primary_endpoint_address = "${aws_elasticache_replication_group.cache.primary_endpoint_address}"
}