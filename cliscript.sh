#It's a shell script that uploads a file to Azure Blob Storage and generates a shareable link.  
#It checks if a file with the same name already exists in the Azure Blob Storage container. 
#If all checks pass, it uploads the file and lists all blobs in the container.

#!/bin/bash

#function to upload file to azure blob storage
upload_to_azure() {
    local file_path=$1
    local container_name=$2
    local blob_name=$(basename "$file_path")
    local storage_account=myaccount

    echo "Uploading file to Azure Blob Storage..."

# check if the file with the same name already exists in the Azure Blob Storage container
az storage blob exists \
    --account-name "$storage_account" \
    --container-name "$container_name" \
    --name "$blob_name" \
    --auth-mode login | grep -q "true" && {

    echo "[!] File with the same name already exists in container '$container_name'!"; exit 1; }


    #check standard error output $ upload file
    error_message=$(az storage blob upload \
        --account-name "$storage_account" \
        --container-name "$container_name" \
        --file "$file_path" \
        --name "$blob_name" \
        --auth-mode login 2>&1 >/dev/null) 

    if [ $? -ne 0 ]; then
        echo "Failed to upload file to Azure Blob Storage"
        echo "Error: $error_message"
    else
        echo "File successfully uploaded"
        echo -n "Do you want to generate a shareable link for the file? [yes/no]: "
        read generate_link

    #generate and display shareable link if requested
        if [[ "$generate_link" == "yes" ]]; then
        shareable_link=$(generate_sas_url "$storage_account" "$container_name" "$blob_name")
        echo "Shareable Link: $shareable_link"
    fi
fi
}

#function to generate a read-only SAS token for blob storage
generate_sas_url() {
    local storage_account=$1
    local container_name=$2
    local blob_name=$3

    local sas_token=$(az storage blob generate-sas \
         --account-name "$storage_account" \
         --container-name "$container_name" \
         --name "$blob_name" \
         --permissions r \
         --expiry $(date -u -d "1 day" '+%Y-%m-%dT%H:%MZ') \
         --auth-mode login \
         --as-user \
         --output tsv 2>&1)
         

    if [ -z "$sas_token" ]|| [[ $sas_token == *"ERROR"* ]]; then
        echo "Failed to generate SAS token for $blob_name.Error: $sas_token"
        return 1
    fi
              
    #display shareable link
    local shareable_link="https://${storage_account}.blob.core.windows.net/${container_name}/${blob_name}?${sas_token}"
    echo "Shareable Link: $shareable_link"
}

# upload the file to Azure Blob Storage and display blob list
upload_to_azure "$container_name" "$blob_name"
echo '[+] Blobs in the container:'
az storage blob list --container-name "$container_name" --output table --auth-mode login

#exit/end script
exit 0

