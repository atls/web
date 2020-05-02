resource "aws_route53_zone" "main" {
  name          = "aunited.pro"
  force_destroy = true

  tags {
    Name        = "aunited.pro-zone-public"
    Infra       = "aunited.pro"
    Terraformed = "true"
  }
}

resource "aws_route53_record" "av_local_root" {
  zone_id = "${aws_route53_zone.main.id}"

  name = "av.local.aunited.pro"
  type = "A"

  ttl     = "300"
  records = ["127.0.0.1"]
}

resource "aws_route53_record" "av_local_wildcard" {
  zone_id = "${aws_route53_zone.main.id}"

  name = "*.av.local.aunited.pro"
  type = "A"

  ttl     = "300"
  records = ["127.0.0.1"]
}

resource "aws_route53_record" "bs_local_root" {
  zone_id = "${aws_route53_zone.main.id}"

  name = "bs.local.aunited.pro"
  type = "A"

  ttl     = "300"
  records = ["127.0.0.1"]
}

resource "aws_route53_record" "bs_local_wildcard" {
  zone_id = "${aws_route53_zone.main.id}"

  name = "*.bs.local.aunited.pro"
  type = "A"

  ttl     = "300"
  records = ["127.0.0.1"]
}

resource "aws_route53_record" "au_wp_root" {
  zone_id = "${aws_route53_zone.main.id}"

  name = "stage.aunited.pro"
  type = "A"

  ttl     = "300"
  records = ["54.237.238.140"]
}

resource "aws_route53_record" "au_wp_wildcard" {
  zone_id = "${aws_route53_zone.main.id}"

  name = "*.stage.aunited.pro"
  type = "A"

  ttl     = "300"
  records = ["54.237.238.140"]
}

resource "aws_route53_record" "examine_docs" {
  zone_id = "${aws_route53_zone.main.id}"

  name = "docs.examine.aunited.pro"
  type = "A"

  ttl     = "300"
  records = ["54.85.121.172"]
}

resource "aws_route53_record" "examine_gateway" {
  zone_id = "${aws_route53_zone.main.id}"

  name = "gateway.examine.aunited.pro"
  type = "A"

  ttl     = "300"
  records = ["54.85.121.172"]
}
