# Guidance

This directory contains guidance on setting up and deploying the External Secrets Operator using Terraform, Kubernetes manifests, and Helm charts.

## 1- AWS IAM Role by Terraform

This directory contains Terraform configurations to set up the necessary IAM role that will have access to specific AWS Secrets Manager secrets.

- `0-providers.tf`: Defines the providers used in the Terraform configuration.
- `1-main.tf`: Main Terraform configuration file.
- `2-variables.tf`: Variable definitions for the Terraform configuration.
- `3-outputs.tf`: Output definitions for the Terraform configuration.
- `4-terraform.tfvars`: Variables file where you define the values for the variables.
- `external-secret-operator.json`: JSON file containing additional configurations or secrets.

### Usage

To apply the Terraform configuration:

```sh
cd 1-Terraform
terraform init
terraform apply
```
This will create the IAM role with the necessary permissions to access AWS Secrets Manager secrets based on the "external-secret-operator.json" file

## 2- Deployment on EKS
- ### 1- Kubernetes Manifests
  - This directory contains Kubernetes manifest files for deploying the External Secrets Operator and related resources.

  - `1-ServiceAccount.yaml`: Service account with the necessary IAM role annotations.
  - `2-SecretStore.yaml`: SecretStore resource definition for AWS Secrets Manager.
  - `3-ExternalSecret.yaml`: ExternalSecret resource definition to sync secrets.
  - `4-nginx-pod.yaml`: Pod definition for an nginx container consuming the synced secrets.

  - ### Usage

    - To apply the Terraform configuration:
    - ```sh
      kubectl apply -f 2-Kubernetes-manifests/
      ```

- ### 2- Helm Charts
  - This directory contains Helm chart configurations for deploying the External Secrets Operator and related resources.
  - `Chart.yaml`: Helm chart metadata.
  - `templates/`: Directory containing the template files for the Helm chart.
    - `serviceaccount.yaml`: Template for creating a service account.
    - `secretstore.yaml`: Template for creating a SecretStore resource.
    - `externalsecret.yaml`: Template for creating an ExternalSecret resource.
    - `pod.yaml`: Template for creating a Pod resource.
  - `values.yaml`: Default values for the Helm chart.
  - ### Usage

    - To install the Helm chart:
    - ```sh
      cd 3-Helm-Charts
      helm install external-secrets-operator . -n dev
      ```