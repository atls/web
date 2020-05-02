resource "aws_acm_certificate" "youtrack" {
  domain_name       = "yt.aunited.pro"
  validation_method = "DNS"
}

resource "aws_route53_record" "youtrack_cert_validation" {
  name    = "${aws_acm_certificate.youtrack.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.youtrack.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.terraform_remote_state.common.zone_id}"
  records = ["${aws_acm_certificate.youtrack.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "youtrack" {
  certificate_arn         = "${aws_acm_certificate.youtrack.arn}"
  validation_record_fqdns = ["${aws_route53_record.youtrack_cert_validation.fqdn}"]
}

resource "aws_ebs_volume" "youtrack" {
  availability_zone = "${element(module.ecs_persisted_instance.availability_zone, 0)}"
  size              = 16
}

resource "aws_volume_attachment" "youtrack" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.youtrack.id}"
  instance_id = "${element(module.ecs_persisted_instance.id, 0)}"
}

resource "null_resource" "prepare_youtrack" {
  connection {
    type        = "ssh"
    port        = 22
    user        = "ec2-user"
    host        = "${element(module.ecs_persisted_instance.public_ip, 0)}"
    private_key = "${file(data.terraform_remote_state.infrastructure.ecs_instance_private_key_path)}"
  }

  provisioner "file" {
    source      = "scripts/prepare-youtrack-volume.sh"
    destination = "/tmp/prepare-youtrack-volume.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/prepare-youtrack-volume.sh",
      "/tmp/prepare-youtrack-volume.sh /dev/sdh",
    ]
  }

  depends_on = [
    "aws_volume_attachment.youtrack",
  ]
}

resource "aws_alb_target_group" "youtrack" {
  name       = "youtrack"
  protocol   = "HTTP"
  port       = 80
  slow_start = 60
  vpc_id     = "${data.terraform_remote_state.infrastructure.vpc_id}"

  health_check {
    path                = "/hub/api/rest/settings/public"
    unhealthy_threshold = 2
    healthy_threshold   = 5
    interval            = 60
    timeout             = 10
    matcher             = "200"
  }
}

resource "aws_alb" "youtrack" {
  name            = "youtrack"
  security_groups = ["${aws_security_group.ecs_lb.id}"]
  subnets         = ["${data.terraform_remote_state.infrastructure.public_subnets}"]
}

resource "aws_alb_listener" "youtrack_http" {
  load_balancer_arn = "${aws_alb.youtrack.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.youtrack.id}"
    type             = "forward"
  }

  depends_on = [
    "aws_alb_target_group.youtrack",
    "aws_alb.youtrack",
  ]
}

resource "aws_alb_listener" "youtrack_https" {
  load_balancer_arn = "${aws_alb.youtrack.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${aws_acm_certificate.youtrack.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.youtrack.id}"
    type             = "forward"
  }

  depends_on = [
    "aws_alb_target_group.youtrack",
    "aws_alb.youtrack",
  ]
}

resource "aws_ecs_task_definition" "youtrack" {
  family = "youtrack"

  volume {
    name      = "data"
    host_path = "/youtrack/data"
  }

  volume {
    name      = "conf"
    host_path = "/youtrack/conf"
  }

  volume {
    name      = "logs"
    host_path = "/youtrack/logs"
  }

  volume {
    name      = "backups"
    host_path = "/youtrack/backups"
  }

  container_definitions = <<DEFINITION
  [{
    "name": "youtrack",
    "portMappings": [{
      "containerPort": 8080,
      "protocol": "tcp"
    }],
    "memoryReservation": 256,
    "image": "jetbrains/youtrack:${var.youtrack_version}",
    "networkMode": "awsvpc",
    "mountPoints": [
      {
        "sourceVolume": "data",
        "containerPath": "/opt/youtrack/data"
      },
      {
        "sourceVolume": "conf",
        "containerPath": "/opt/youtrack/conf"
      },
      {
        "sourceVolume": "logs",
        "containerPath": "/opt/youtrack/logs"
      },
      {
        "sourceVolume": "backups",
        "containerPath": "/opt/youtrack/backups"
      }
    ]
  }]
  DEFINITION

  placement_constraints {
    type       = "memberOf"
    expression = "ec2InstanceId == ${element(module.ecs_persisted_instance.id, 0)}"
  }
}

resource "aws_ecs_service" "youtrack" {
  name            = "youtrack"
  task_definition = "${aws_ecs_task_definition.youtrack.arn}"
  cluster         = "${data.terraform_remote_state.infrastructure.ecs_cluster}"
  iam_role        = "${data.terraform_remote_state.infrastructure.ecs_iam_role}"
  desired_count   = 1

  load_balancer {
    target_group_arn = "${aws_alb_target_group.youtrack.id}"
    container_name   = "youtrack"
    container_port   = 8080
  }

  depends_on = [
    #"aws_alb_listener.youtrack_https",
    "aws_alb_listener.youtrack_http",
  ]
}

resource "aws_route53_record" "youtrack" {
  name    = "yt"
  zone_id = "${data.terraform_remote_state.common.zone_id}"
  type    = "A"

  alias {
    name                   = "${aws_alb.youtrack.dns_name}"
    zone_id                = "${aws_alb.youtrack.zone_id}"
    evaluate_target_health = true
  }
}
