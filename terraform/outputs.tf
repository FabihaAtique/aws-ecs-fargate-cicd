output "app_url" {
  description = "URL of the application"
  value       = local.enable_https ? "https://${var.domain_name}" : "http://${aws_lb.app.dns_name}"
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  value = aws_ecs_service.app.name
}

output "task_definition_family" {
  value = aws_ecs_task_definition.app.family
}

output "github_deploy_role_arn" {
  description = "Set this as the AWS_DEPLOY_ROLE_ARN variable in GitHub"
  value       = local.create_deploy_role ? aws_iam_role.github_deploy[0].arn : null
}
