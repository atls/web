resource "aws_route53_zone" "dev" {
  name          = "aunited.dev"
  force_destroy = true

  tags {
    Name        = "aunited.dev-zone-public"
    Infra       = "aunited.dev"
    Terraformed = "true"
  }
}

resource "aws_route53_record" "av_local_root" {
  zone_id = aws_route53_zone.dev.id

  name = "av.local.aunited.dev"
  type = "A"

  ttl     = 300
  records = ["127.0.0.1"]
}

resource "aws_route53_record" "av_local_wildcard" {
  zone_id = aws_route53_zone.dev.id

  name = "*.av.local.aunited.dev"
  type = "A"

  ttl     = 300
  records = ["127.0.0.1"]
}

resource "aws_route53_record" "bs_local_root" {
  zone_id = aws_route53_zone.dev.id

  name = "bs.local.aunited.dev"
  type = "A"

  ttl     = 300
  records = ["127.0.0.1"]
}

resource "aws_route53_record" "bs_local_wildcard" {
  zone_id = aws_route53_zone.dev.id

  name = "*.bs.local.aunited.dev"
  type = "A"

  ttl     = 300
  records = ["127.0.0.1"]
}

resource "aws_route53_record" "sy_local_root" {
  zone_id = aws_route53_zone.dev.id

  name = "sy.local.aunited.dev"
  type = "A"

  ttl     = 300
  records = ["127.0.0.1"]
}

resource "aws_route53_record" "sy_local_wildcard" {
  zone_id = aws_route53_zone.dev.id

  name = "*.sy.local.aunited.dev"
  type = "A"

  ttl     = 300
  records = ["127.0.0.1"]
}
