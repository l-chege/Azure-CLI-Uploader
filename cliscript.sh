#!/bin/bash

#function to upload file to azure blob storage
upload_to_azure() {
    local container_name=containercli
    local storage_account=azcliuploader
    local bob_name=$(basename "$1")

    #upload file to azure blob storage
    echo "Uploading file to Azure Blob Storage..."
    az storage blob upload --account-name "$storage_account" --container-name "$container_name" --file "$1" --name "$blob_name" --auth-mode login 2>&1 >/dev/null || { echo "File upload failed"; exit 1; }

    # Display success message
    echo "File successfully uploaded."

    #prompt user to generate a shareable link
    read -r  -p "Do you want to generate a shareable link for the file? [yes/no]: " generate_link
