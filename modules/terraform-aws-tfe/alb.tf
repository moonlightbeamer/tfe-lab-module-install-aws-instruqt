#-------------------------------------------------------------------------------------------------------------------------------------------
# Application Load Balancer
#-------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_lb" "alb" {
  count = var.load_balancer_type == "alb" ? 1 : 0

  name               = "${var.friendly_name_prefix}-tfe-web-alb"
  internal           = var.load_balancer_scheme == "external" ? false : true
  load_balancer_type = "application"
  subnets            = var.lb_subnet_ids

  security_groups = [
    aws_security_group.alb_ingress_allow[0].id,
    aws_security_group.alb_egress_allow[0].id
  ]

  tags = merge({ "Name" = "${var.friendly_name_prefix}-tfe-alb" }, var.common_tags)
}

resource "aws_lb_listener" "alb_443" {
  count = var.load_balancer_type == "alb" ? 1 : 0

  load_balancer_arn = aws_lb.alb[0].arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = element(coalescelist(aws_acm_certificate.cert[*].arn, tolist([var.tfe_tls_certificate_arn])), 0)

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_443[0].arn
  }

  depends_on = [aws_acm_certificate.cert]
}

resource "aws_lb_listener" "alb_8800" {
  count = var.load_balancer_type == "alb" && var.enable_active_active == false ? 1 : 0

  load_balancer_arn = aws_lb.alb[0].arn
  port              = 8800
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = element(coalescelist(aws_acm_certificate.cert[*].arn, tolist([var.tfe_tls_certificate_arn])), 0)

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_8800[0].arn
  }

  depends_on = [aws_acm_certificate.cert[0]]
}

resource "aws_lb_target_group" "alb_443" {
  count = var.load_balancer_type == "alb" ? 1 : 0

  name     = "${var.friendly_name_prefix}-tfe-alb-tg-443"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    protocol            = "HTTPS"
    path                = "/_health_check"
    healthy_threshold   = 2
    unhealthy_threshold = 7
    timeout             = 5
    interval            = 30
    matcher             = 200
  }

  tags = merge(
    { "Name" = "${var.friendly_name_prefix}-tfe-alb-tg-443" },
    { "Description" = "ALB Target Group for TFE web application HTTPS traffic" },
    var.common_tags
  )
}

resource "aws_lb_target_group" "alb_8800" {
  count = var.load_balancer_type == "alb" && var.enable_active_active == false ? 1 : 0

  name     = "${var.friendly_name_prefix}-tfe-alb-tg-8800"
  port     = 8800
  protocol = "HTTPS"
  vpc_id   = var.vpc_id

  health_check {
    protocol            = "HTTPS"
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 7
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = merge(
    { "Name" = "${var.friendly_name_prefix}-tfe-alb-tg-8800" },
    { "Description" = "ALB Target Group for TFE/Replicated web admin console traffic over port 8800" },
    var.common_tags
  )
}

#-------------------------------------------------------------------------------------------------------------------------------------------
# Security Groups
#-------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "alb_ingress_allow" {
  count = var.load_balancer_type == "alb" ? 1 : 0

  name   = "${var.friendly_name_prefix}-tfe-lb-allow"
  vpc_id = var.vpc_id

  tags = merge({ "Name" = "${var.friendly_name_prefix}-tfe-lb-allow" }, var.common_tags)
}

resource "aws_security_group_rule" "alb_ingress_allow_https" {
  count = var.load_balancer_type == "alb" ? 1 : 0

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = var.ingress_cidr_443_allow
  description = "Allow HTTPS (port 443) traffic inbound to TFE LB"

  security_group_id = aws_security_group.alb_ingress_allow[0].id
}

resource "aws_security_group_rule" "alb_ingress_allow_console" {
  count = var.load_balancer_type == "alb" ? 1 : 0

  type        = "ingress"
  from_port   = 8800
  to_port     = 8800
  protocol    = "tcp"
  cidr_blocks = var.ingress_cidr_8800_allow == null ? var.ingress_cidr_443_allow : var.ingress_cidr_8800_allow
  description = "Allow admin console (port 8800) traffic inbound to TFE LB for TFE Replicated admin console"

  security_group_id = aws_security_group.alb_ingress_allow[0].id
}

resource "aws_security_group" "alb_egress_allow" {
  count = var.load_balancer_type == "alb" ? 1 : 0

  name   = "${var.friendly_name_prefix}-tfe-alb-egress-allow"
  vpc_id = var.vpc_id
  tags   = merge({ "Name" = "${var.friendly_name_prefix}-tfe-alb-egress-allow" }, var.common_tags)
}

resource "aws_security_group_rule" "alb_egress_allow_all" {
  count = var.load_balancer_type == "alb" ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow all traffic outbound from the ALB"

  security_group_id = aws_security_group.alb_egress_allow[0].id
}
