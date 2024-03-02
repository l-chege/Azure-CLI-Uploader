# Azure Resources Set-Up
## Prerequisites 
Before using the Azure Cloud CLI-Uploader tool, ensure you have the following: 

### 1. Choose a cloud provider (Microsoft Azure is used in this project).  

### 2. Have an active Azure subscription.  

If you’re new to Azure, create an Azure free account. Use this [link](https://azure.microsoft.com/en-us/free/) to get started.  

### 3. A Bash environment available on Linux/Unix, WSL (Windows Subsystem for Linux), or macOS.  

Check if bash is installed in your system; open a terminal and run the command: 
```
bash --version 
```

If bash is not installed, you can install it using your system’s package manager and customize your environment to suit your preferences and requirements. Checkout the installation guide for bash on different systems/platforms 

### 4. Have Azure CLI tool installed and authenticated. 

Setting up Azure CLI allows one to manage Azure resources directly from the command-line (cmd) or terminal.  

Check out the installation page, follow instructions provided for your Operating System to download and install the [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).  

Once done run the command to verify its installation: 
```
az --version 
```
Initiate the login process by running the command:  
```
az login 
```
Once logged in, verify Azure CLI configuration:  
```
az account show 
```
 ## Let's setup Azure resources 

### 1. Create a resource group 

A resource group is a logical container for grouping Azure resources. Create one using the Azure CLI: 
```
az group create --name <resource-group-name> --location <location> 
``` 
### 2. Ensure enrolment to Microsoft.Storage Resource Provider: 

Microsoft.Storage resource provider, typically enabled by default, allows you to create storage accounts. Ensure its enrolled by using:  
```
az provider register --namespace Microsoft.Storage 
```

### 3. Create storage account 

Once resource provider is enabled, you can create a storage account within your resource group:  
```
az storage account create --name <storage-account-name> --resource-group <resource-group-name> --location <location> --sku Standard_LRS 
```
 
### 4. Create a blob storage and container within the storage account: 

```
az storage blob upload --file <local-file-path> --container-name <container-name> --name <blob-name> --account-name <storage-account-name> 
```
 
### 5. Assign storage blob data contributor role: 

Assign Storage Blob Data Contributor role to yourself or your user identity to perform data operations against the storage account: 
```
az role assignment create --role "Storage Blob Data Contributor" --assignee <your-username-or-object-id> --scope /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name> 
```
 
### 6. Set values for storage account and storage access key. 
The command lists the keys for specified storage account:  
```
az storage account keys list --account-name <storage-account-name> --resource-group <resource-group-name>  
```
Use jq command to simplify the output and just lists the key values: 
```
az storage account keys list --account-name <storage-account-name> --resource-group <resource-group-name> | jq '.[0,1].value?' 
```

### 7. Export values (storage account name and access key) as environment variables: 
```
export AZURE_STORAGE_ACCOUNT="<storage-account-name>" ; export AZURE_STORAGE_KEY="<storage-account-access-key>" 
```
 