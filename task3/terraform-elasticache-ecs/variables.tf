variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "10.99.0.0/16"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["10.99.1.0/24", "10.99.2.0/24"]
}

variable "namespace" {
  description = "Default namespace"
}

variable "cluster_id" {
  description = "Id to assign the new cluster"
}

variable "node_groups" {
  description = "Number of nodes groups to create in the cluster"
  default     = 3
}

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "ap-southeast-1"
}

variable "health_check_path" {
  description = "path for alb to health check"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
}

variable "environment" {
  description = "uat/production"
}

variable "app_repo" {
  description = "Docker image to run in the ECS cluster"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
}

variable "app_count" {
  description = "Number of docker containers to run"
}

variable "app" {
  description = "app name"
}