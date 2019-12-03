resource "aws_ecs_cluster" "main" {
  name = "${var.app}-${var.environment}"
}

data "template_file" "app" {
  template = "${file("${path.module}/templates/ecs/app.json.tpl")}"

  vars = {
    app             = "${var.app}"
    app_image       = "${var.app_repo}:latest"
    fargate_cpu     = "${var.fargate_cpu}"
    fargate_memory  = "${var.fargate_memory}"
    aws_region      = "${var.aws_region}"
    app_port        = "${var.app_port}"
    log             = "/ecs/${var.app}-app/${var.environment}"
    REDIS_ENDPOINT  = "${split(":", aws_elasticache_replication_group.default.configuration_endpoint_address)[0]}"
    REDIS_PASSWORD  = ""
    REDIS_PORT      = ""
    HTTPS_ENABLE    = "False"
    DOMAIN          = "${aws_alb.main.dns_name}"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app}-${var.environment}-task"
  execution_role_arn       = "${aws_iam_role.fargate_task_execution_role.arn}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
  container_definitions    = "${data.template_file.app.rendered}"
  tags = "${
    map(
      "Name", "${var.app}-task",
      "environment", "${var.environment}",
    )
  }"
}

resource "aws_ecs_service" "main" {
  name            = "${var.app}-service"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.app.arn}"
  desired_count   = "${var.app_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = ["${aws_security_group.ecs_tasks.id}"]
    subnets          = "${aws_subnet.default.*.id}"
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.app.id}"
    container_name   = "${var.app}-app"
    container_port   = "${var.app_port}"
  }

  depends_on = [
    "aws_alb_listener.front_end",
  ]
  lifecycle {
    ignore_changes = ["desired_count"]
  }
}
