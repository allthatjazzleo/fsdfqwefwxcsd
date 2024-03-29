# Set up cloudwatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/${var.app}-app/${var.environment}"
  retention_in_days = 30
  tags = {
    Name = "${var.app}-${var.environment}-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "${var.app}-log-stream"
  log_group_name = "${aws_cloudwatch_log_group.log_group.name}"
}
