output "zone_id" {
  value = "${aws_route53_zone.dev.id}"
}

output "zone_name" {
  value = "${aws_route53_zone.dev.name}"
}
