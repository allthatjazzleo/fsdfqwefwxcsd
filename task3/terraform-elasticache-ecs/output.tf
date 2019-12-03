output "configuration_endpoint_address" {
  value = "${aws_elasticache_replication_group.default.configuration_endpoint_address}"
}

output "alb_endpoint_address" {
  value = "${aws_alb.main.dns_name}"
}
