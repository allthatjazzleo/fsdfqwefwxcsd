namespace = "fsdfqwefwxcsd-url-shorten"

cluster_id = "redis-cluster"

node_groups = 2

aws_region     = "ap-southeast-1"
app            = "url-shorten-app"
app_repo       = "allthatjazzleo/fsdfqwefwxcsd"
app_count      = 1
app_port       = 3000
environment    = "prod"
health_check_path = "/ping"
fargate_cpu    = "1024"
fargate_memory = "2048"
