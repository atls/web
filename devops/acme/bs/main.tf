resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "acme_registration" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "admin@aunited.pro"
}

resource "acme_certificate" "local_certificate" {
  account_key_pem = "${acme_registration.acme_registration.account_key_pem}"
  common_name     = "bs.local.${var.route_zone}"

  subject_alternative_names = [
    "*.bs.local.${var.route_zone}",
  ]

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = "${data.terraform_remote_state.aunited_dev.zone_id}"
    }
  }
}

resource "local_file" "local_certificate" {
  content  = "${acme_certificate.local_certificate.certificate_pem}"
  filename = "cert.crt"
}

resource "local_file" "local_private_key" {
  content  = "${acme_certificate.local_certificate.private_key_pem}"
  filename = "cert.key"
}

resource "local_file" "issuer_certificate" {
  content  = "${acme_certificate.local_certificate.issuer_pem}"
  filename = "issuer.pem"
}
