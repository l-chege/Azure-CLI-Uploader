#!/bin/bash

#function to upload file to azure blob storage
upload_to_azure() {
    local container_name=containercli
    local storage_account=azcliuploader
    local bob_name=$(basename "$1")

    #upload file to azure blob storage
    echo "Uploading file to Azure Blob Storage..."
    az storage blob upload 
    --account-name "$storage_account" 
    --container-name "$container_name" 
    --file "$1" 
    --name "$blob_name" 
    --auth-mode login 2>&1 >/dev/null || { 

        echo "File upload failed"; exit 1; }

    # Display success message
    echo "File successfully uploaded."

    #prompt user to generate a shareable link
    read -r  -p "Do you want to generate a shareable link for the file? [yes/no]: " generate_link

    #generate and display shareable link if requested
    [[ "$generate_link" == "yes" ]] && echo "Shareable link: $(generate_sas_url "$storage_account" "$container_name" "$blob_name")"
}

#function to generate a shareable link
generate_sas_url() {
    local storage_account=$1
    local container_name=containercli
    local blob_namme=$3

    #generate sas token for the blob
    local sas_token=$(az storage blob generate-sas
     --account-name "$storage_account"
     --container-name "$container_name" 
     --name "$blob_name" 
     --permissions r --expiry $(date -u -d "1 hour" '+%Y-%m-%dT%H:%MZ') --output tsv 2>&1 || { 
        echo "Failed to generate SAS token for $blob_name"; exit 1; })

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
upload_to_azure "$file_name"
echo '[+] Blobs in the container:'
az storage blob list --container-name "$container_name" --output table --auth-mode login

#exit/end script
exit 0

