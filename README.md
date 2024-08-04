# External Secrets Operator

The External Secrets Operator syncs secrets from external stores like AWS Secrets Manager, Azure Key Vault, and HashiCorp Vault into Kubernetes Secrets. It enhances security and simplifies secret management in Kubernetes, supporting a cloud-agnostic strategy.

## Features

- Sync secrets from multiple external secret stores
- Automatic secret synchronization
- Supports AWS Secrets Manager, Azure Key Vault, and HashiCorp Vault

## Prerequisites

- Kubernetes cluster
- Access to external secret stores

## Installation

### 1-Install from chart repository

```bash
helm repo add external-secrets https://charts.external-secrets.io

helm install external-secrets \
   external-secrets/external-secrets \
   -n external-secrets \
   --create-namespace
```

### 2-Install using Terraform
**_NOTE:_**  Make sure you've installed aws-cli 
#### Providers.tf file

```
provider "aws" {
  region = "eu-west-1"
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.59.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.6.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
  }
}
# Define the Kubernetes provider to manage resources on the EKS cluster
provider "kubernetes" {
  # The address of the EKS cluster
  host = module.eks.cluster_endpoint
  # Cluster CA certificate for authenticating to the cluster
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  # Configuration for authenticating using AWS CLI
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}
# Define the Helm provider to manage Helm charts on the EKS cluster
provider "helm" {
  # Configuration for interacting with the EKS cluster
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    # Configuration for authenticating using AWS CLI
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}
```
#### variables.tf file

```
variable "external-secrets-operator-config" {
  description = "Configuration for deploying external secrets operator"
  type = object({
    enable                  = bool
    helmChartVersion        = string
    helm_values_file        = optional(list(string))
  })
  default = {
    enable                  = true
    helmChartVersion        = "0.10.0"
    helm_values_file        = []
  }
}
```
#### main.tf file
```
resource "helm_release" "external-secrets-operator" {
  count        = lookup(var.external-secrets-operator-config, "enable") ? 1 : 0
  name         = "external-secrets-operator-release"
  chart        = "external-secrets"
  repository   = "https://charts.external-secrets.io"
  version      = lookup(var.external-secrets-operator-config, "helmChartVersion")
  force_update = true
  namespace    = "external-secrets"
  values       = lookup(var.external-secrets-operator-config, "helm_values_file")
}
```
