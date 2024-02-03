#!/bin/bash

#function to upload file to azure blob storage
upload_to_azure() {
    local container_name=$1
    local file_path=$2

    # Extracting storage account name from container name (assuming format: "<storage-account-name>/<container-name>")
    local storage_account=$(echo "$container_name" | cut -d'/' -f1)

    echo "Uploading file to Azure Blob Storage..."

    # Upload the file to Azure Blob Storage
    local blob_name=$(basename "$file_path")
    az storage blob upload \
        --account-name "$storage_account" \
        --container-name "$container_name" \
        --name "$blob_name" \
        --type block \
        --auth-mode login \
        --file "$file_path" || { echo "File upload failed"; exit 1; }

    # Display success message
    echo "File successfully uploaded"

    #prompt user to generate a shareable link
    read -r  -p "Do you want to generate a shareable link for the file? [yes/no]: " generate_link

    #generate and display shareable link if requested
   if [[ "$generate_link" == "yes" ]]; then
        shareable_link=$(generate_sas_url "$storage_account" "$container_name" "$blob_name")
        echo "Shareable Link: $shareable_link"
    fi
}
#function to generate a shareable link
generate_sas_url() {
    local storage_account=$1
    local container_name=$2
    local blob_name=$3

    #generate sas token for the blob
    local sas_token=$(az storage blob generate-sas \
     --account-name "$storage_account" \
     --container-name "$container_name" \
     --name "$blob_name" \
     --permissions r \
     --expiry $(date -u -d "1 hour" '+%Y-%m-%dT%H:%MZ') \
     --output tsv 2>&1 || { 
        echo "Failed to generate SAS token for $blob_name"; exit 1; })

    #display shareable link
    local shareable_link="https://${storage_account}.blob.core.windows.net/${container_name}/${blob_name}?${sas_token}"
    echo "Shareable Link: $shareable_link"
}

#main script logic
# Check if correct number of arguments is provided and the file exists
[[ $# -eq 2 && -f $2 ]] || { 
    echo '[X] Incorrect number of arguments or file does not exist'; 
    echo '[!] Usage: ./cliscript <container-name> <file-name1>'; exit 1; }

container_name=$1
file_name=$2    

# Check if the file with the same name already exists in the Azure Blob Storage container
az storage blob exists --container-name "$container_name" --name "$file_name" --auth-mode login | grep -q "true" && {
    echo "[!] File with the same name already exists in container '$container_name'!"; exit 1; }

# Upload the file to Azure Blob Storage and display blob list
upload_to_azure "$container_name" "$file_name"
echo '[+] Blobs in the container:'
az storage blob list --container-name "$container_name" --output table --auth-mode login

#exit/end script
exit 0

