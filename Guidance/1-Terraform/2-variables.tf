variable "tags" {
  type        = map(any)
  description = "Map of Default Tags for the IAM role"
}
variable "role_name" {
  type        = string
  description = "Role name for the IAM role with OIDC"
}
variable "oidc_provider_url" {
  type        = string
  description = "URL of the OIDC provider for IAM role authentication" # ex: https://oidc.eks.<Region>.amazonaws.com/id/<OIDC_Issuer_Id>
}
variable "policy_name" {
  type        = string
  description = "Name of the IAM policy"
}
variable "policy_path" {
  type        = string
  description = "Path to the IAM policy template file"
}
