resource "aws_iam_role" "fargate_task_execution_role" {
  name = "${var.app}_${var.environment}_task_execution_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {
      "Service": "ecs-tasks.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }
} 
EOF
}

# Attach the managed AmazonECSTaskExecutionRolePolicy to the newly created fargate_task_execution_role role
resource "aws_iam_role_policy_attachment" "attach_managed_task_execution_policy_to_role" {
  role      = "${aws_iam_role.fargate_task_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}