variable "project" {
  description = "Name prefix for all resources"
  type        = string
  default     = "fargate-cicd-demo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "poc"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to spread subnets across"
  type        = number
  default     = 2
}

variable "private_tasks" {
  description = "Run tasks in private subnets behind a NAT gateway (production pattern, adds ~$1/day). When false, tasks run in public subnets with a public IP but only accept traffic from the ALB."
  type        = bool
  default     = false
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8000
}

variable "task_cpu" {
  description = "Fargate task CPU units"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Fargate task memory (MiB)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Initial number of tasks"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum number of tasks for autoscaling"
  type        = number
  default     = 3
}

variable "image_tag" {
  description = "Image tag used for the initial task definition. CI/CD registers new revisions after that."
  type        = string
  default     = "latest"
}

variable "create_database" {
  description = "Create a small RDS Postgres instance for the app"
  type        = bool
  default     = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_engine_version" {
  description = "Postgres major version"
  type        = string
  default     = "16"
}

variable "db_username" {
  description = "Master username for RDS (password is generated and stored in Secrets Manager)"
  type        = string
  default     = "appadmin"
}

variable "github_repo" {
  description = "GitHub repository allowed to deploy, as owner/repo. Leave empty to skip creating the deploy role."
  type        = string
  default     = ""
}

variable "create_github_oidc_provider" {
  description = "Create the GitHub OIDC provider. Set to false if the account already has one."
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Optional domain (e.g. app.example.com). With hosted_zone_id set, enables HTTPS with ACM."
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID for domain_name"
  type        = string
  default     = ""
}

variable "alarm_email" {
  description = "Optional email for CloudWatch alarm notifications"
  type        = string
  default     = ""
}
