#! /bin/sh

# Provision ECS fargate and EleastiCache with terraform
cd terraform-elasticache-ecs
terraform init
terraform apply --auto-approve
