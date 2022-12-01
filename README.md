# AzPKR-AVD

## Setup 

### Create Azure Credentials
1. Create a Service Principal for Packer to use for image creation using the command below, replacing `<subscription-id>` with the Azure Subscription GUID that the SP permissions should be scoped to.
    ```bash
    az ad sp create-for-rbac --name "packer-sp-01" --role "Contributor" --scopes /subscriptions/<subscription-id> --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"
    ```
1. Copy and save the output of the the above command. You will need the `client_id`, `client_secret`, and `tenant_id` values to create GitHub Actions Secrets. 
1. Create Github Actions Secrets for the `sub_id` `client_id`, `client_secret`, and `tenant_id` values from the previous step. 
    - Navigate to the GitHub repository Settings > Secrets > Actions > New Repository Secret
    - Create a new secret for each of the `sub_id` `client_id`, `client_secret`, and `tenant_id` values from the previous step. 

### Environment Setup
