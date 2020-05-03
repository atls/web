resource "aws_route53_zone" "main" {
  name          = "aunited.pro"
  force_destroy = true

  tags = {
    Name        = "aunited.pro-zone-public"
    Infra       = "aunited.pro"
    Terraformed = "true"
  }
}

resource "aws_route53_record" "al_github_verify" {
  name    = "_github-challenge-atlantisunited.aunited.pro."
  type    = "TXT"
  zone_id = aws_route53_zone.main.id
  records = ["4fa99e227b"]
  ttl     = 3600
}

resource "aws_route53_record" "al_txt_records" {
  name    = "aunited.pro"
  type    = "TXT"
  zone_id = aws_route53_zone.main.id
  records = [
    "google-site-verification=apWyVxRdzZSxqbYTYvP2ufglMkcyMCTXtO8fSfkhyF8",
    "yandex-verification: e24e1942cc9c6468"
  ]
  ttl     = 3600
}

resource "aws_route53_record" "al_yandex_mail" {
  name    = "aunited.pro"
  type    = "MX"
  zone_id = aws_route53_zone.main.id
  records = ["10 mx.yandex.net"]
  ttl     = 1800
}

resource "aws_route53_record" "au_wp_root" {
  zone_id = aws_route53_zone.main.id

  name    = "aunited.pro"
  type    = "A"

  ttl     = 300
  records = ["54.237.238.140"]
}

resource "aws_route53_record" "au_wp_wildcard" {
  zone_id = aws_route53_zone.main.id

  name    = "*.aunited.pro"
  type    = "A"

  ttl     = 300
  records = ["54.237.238.140"]
}

resource "aws_route53_record" "examine_docs" {
  zone_id = aws_route53_zone.main.id

  name    = "docs.examine.aunited.pro"
  type    = "A"

  ttl     = 300
  records = ["54.85.121.172"]
}

resource "aws_route53_record" "examine_gateway" {
  zone_id = aws_route53_zone.main.id

  name    = "gateway.examine.aunited.pro"
  type    = "A"

  ttl     = 300
  records = ["54.85.121.172"]
}
