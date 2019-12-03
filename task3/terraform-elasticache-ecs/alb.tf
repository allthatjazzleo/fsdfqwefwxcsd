resource "aws_alb" "main" {
  name            = "${var.app}-${var.environment}-lb"
  subnets         = "${aws_subnet.default.*.id}"
  security_groups = ["${aws_security_group.lb_r.id}","${aws_security_group.lb_g.id}"]
}

resource "aws_alb_target_group" "app" {
  name        = "${var.app}-${var.environment}-tg"
  port        = "${var.app_port}"
  protocol    = "HTTP"
  vpc_id      = "${aws_vpc.default.id}"
  target_type = "ip"

  health_check {

    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "${var.health_check_path}"
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "${data.aws_acm_certificate.cert.arn}"
  default_action {
    target_group_arn = "${aws_alb_target_group.app.id}"
    type             = "forward"
  }
}

# Fetch ACM cert for ALB

# data "aws_acm_certificate" "cert" {
#   domain      = ""
#   types       = ["AMAZON_ISSUED"]
#   most_recent = true
# }