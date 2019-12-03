# ALB Security Group: Edit this to restrict access to the application
resource "aws_security_group" "lb_r" {
  name        = "cloudfront_r"
  description = "controls access to the ALB"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "cloudfront_r",
    AutoUpdate = "true",
    Protocol = "http"
  }
}
# ALB Security Group: Edit this to restrict access to the application
resource "aws_security_group" "lb_g" {
  name        = "cloudfront_g"
  description = "controls access to the ALB"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "cloudfront_g",
    AutoUpdate = "true",
    Protocol = "http"
  }
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "${var.app}-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.app_port}"
    to_port         = "${var.app_port}"
    security_groups = ["${aws_security_group.lb_r.id}","${aws_security_group.lb_g.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

