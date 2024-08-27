# tf-aws-multi-account-deployment-gh-actions
This repository contains a Terraform-based setup for managing AWS multi-account deployments using GitHub Actions. It enables you to provision and manage resources across multiple AWS accounts through a CI/CD pipeline. This approach facilitates infrastructure as code (IaC) practices while ensuring secure, automated, and consistent deployments.

## Features
- Multi-Account Support: Deploy resources across multiple AWS accounts from a single Terraform configuration.
- GitHub Actions Integration: Utilize GitHub Actions to automate the deployment process, including plan, apply, and destroy steps.
- Terraform Remote Backend: Store Terraform state files securely using AWS S3 and DynamoDB for state locking.
- Environment Segregation: Support for different environments (e.g., dev, staging, production) with separate AWS accounts.
- Secure AWS Access: AWS OIDC for Github to access AWS resources without needing long-term IAM user access keys.


### Setup Instructions

#### Clone the repository:

```
git clone https://github.com/sarubhai/tf-aws-multi-account-deployment-gh-actions.git
cd tf-aws-multi-account-deployment-gh-actions
```

#### Configure GitHub Secrets: 
In your GitHub repository, add the following secrets:

- AWS_ACCOUNT_ID_ADM: 111111111111
- AWS_ACCOUNT_ID_STG: 888888888888
- AWS_ACCOUNT_ID_PRO: 999999999999
- TFSTATE_BUCKET_STG: iac-tf-state-gh-actions-stg
- AWS_DYNAMODB_TABLE_STG: iac-tf-state-lock-gh-actions-stg
- TFSTATE_BUCKET_PRO: iac-tf-state-gh-actions-pro
- AWS_DYNAMODB_TABLE_PRO: iac-tf-state-lock-gh-actions-pro

#### Customize Terraform Configuration:
Modify the main.tf, or Add other terraform configuration files to suit your specific needs, including setting up the correct AWS region and resources.

GitHub Actions Workflow: The included workflow (.github/workflows/terraform.yml) will automatically trigger Terraform commands based on the GitHub Actions push event. Customize the workflow if necessary.


You can refer this [article](https://appdev24.com/pages/60/automating-aws-infrastructure-provisioning-with-terraform-and-github-actions) for complete understanding
