[
  {
    "name": "${app}-app",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "Environment" : [
      {
        "Name": "REDIS_ENDPOINT",
        "Value": "${REDIS_ENDPOINT}"
      },
      {
        "Name": "REDIS_PASSWORD",
        "Value": "${REDIS_PASSWORD}"
      },
      {
        "Name": "REDIS_PORT",
        "Value": "${REDIS_PORT}"
      },
      {
        "Name": "HTTPS_ENABLE",
        "Value": "${HTTPS_ENABLE}"
      },
      {
        "Name": "DOMAIN",
        "Value": "${DOMAIN}"
      }
    ],
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${log}",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ]
  }
]