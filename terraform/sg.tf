##########################
#     SECURITY GROUPS    #
##########################
resource "aws_security_group" "service" {
  name        = "${local.environmental_name}-sg"
  description = "Allow traffic to ${var.service_name} service"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [var.alb_securitygroup_id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
