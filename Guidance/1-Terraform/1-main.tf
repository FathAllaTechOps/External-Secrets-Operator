# Retrieve current AWS account information
data "aws_caller_identity" "current" {}

# Declare the iam_assumable_role_with_oidc module
module "iam_assumable_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.28.0"

  # Enable the creation of the IAM role
  create_role = true

  # OIDC configuration
  provider_url                  = module.cluster_eks.oidc_provider

  role_name = "ExternalSecretsRole"
  # Conditionally set role_policy_arns
  role_policy_arns = aws_iam_policy.policy.arn

  # Tags for the IAM Role
  tags = var.tags
}

# Define the IAM policy only if policy_path is provided
resource "aws_iam_policy" "policy" {
  name        = "ExternalSecrets-access-policy"
  description = "Allows access to AWS Secret manager resources"

  # Use a template file to generate the policy with dynamic values
  policy = templatefile("${var.policy_path}", {
    account_id    = data.aws_caller_identity.current.id,
    s3_bucket_arn = var.s3_bucket_arn
  })
}