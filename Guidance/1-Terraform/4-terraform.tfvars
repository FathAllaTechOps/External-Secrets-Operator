tags = {
  Environment = "Development"
}
role_name         = "ExternalSecretsRole"
oidc_provider_url = "https://oidc.eks.eu-west-1.amazonaws.com/id/12345678901234567890123456789012"
policy_name       = "ExternalSecrets-access-policy"
policy_path       = "./external-secret-operator.json"
