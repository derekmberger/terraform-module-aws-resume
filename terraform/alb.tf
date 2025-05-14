##########################
#     ALB RESOURCES      #
##########################
resource "aws_alb_target_group" "tg" {
  name                          = "${local.environmental_name}-tg"
  port                          = 3000
  protocol                      = "HTTP"
  vpc_id                        = var.vpc_id
  target_type                   = "ip"
  load_balancing_algorithm_type = "round_robin"
  proxy_protocol_v2             = false
  deregistration_delay          = 60

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    path                = "/api/health"
    matcher             = "200-299"
    port                = 3000
    protocol            = "HTTP"
  }
}

resource "aws_lb_listener_rule" "http_rule" {
  listener_arn = var.http_listener_arn
  priority     = 49

  action {
    type  = "redirect"
    order = 1
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header { values = ["${local.environmental_name}.${var.domain_name}"] }
  }
}

resource "aws_lb_listener_rule" "https_rule" {
  listener_arn = var.https_listener_arn
  priority     = 50

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg.arn
  }

  condition {
    host_header { values = ["${local.environmental_name}.${var.domain_name}"] }
  }
}

resource "aws_lb_listener_certificate" "cert_attachment" {
  count = var.alb_listener_cert_arn == "" ? 0 : 1

  listener_arn    = var.https_listener_arn
  certificate_arn = var.alb_listener_cert_arn
}
