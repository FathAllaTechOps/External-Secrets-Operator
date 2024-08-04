output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = module.iam_assumable_role_with_oidc.iam_role_arn
}
