#! /bin/sh

# Destroy ECS fargate and EleastiCache with terraform
cd terraform-elasticache-ecs

terraform destroy --auto-approve