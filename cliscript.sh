#!/bin/bash

# Check the number of arguments provided
if [[ $# -eq 0 ]]; then
    echo '[X] No arguments provided'
    echo '[!] Usage: ./cloudloader <container-name> <file-name1>'
    exit 1
elif [[ $# -eq 1 ]]; then
    echo '[X] Too few arguments provided!'
    echo '[!] Usage: ./cloudloader <container-name> <file-name1>'
    exit 1
elif [[ $# -ge 3 ]]; then
    echo '[X] Too many arguments provided!'
    echo '[!] Usage: ./cloudloader <container-name> <file-name1>'
    exit 1
elif [[ ! -f $2 ]]; then
    echo '[X] File does not exist!'
    exit 1
else
    # Check if the file with the same name already exists in Azure Blob Storage
    does_exist=$(az storage blob exists --container-name $1 --name $2 --auth-mode login | grep exists)
    
    if [[ $does_exist == *"true"* ]]; then
        echo '[!] File with the same name already exists!'
        exit 1
    else
        # Upload the file to Azure Blob Storage
        echo '[+] Uploading file to Azure Blob Storage...'
        az storage blob upload --container-name $1 --file $2 --auth-mode login
        echo '[+] File uploaded successfully!'
        
        # List the blobs in the container after upload
        echo '[+] Blobs in the container:'
        az storage blob list --container-name $1 --output table --auth-mode login
        
        exit 0  # Exit with success code
    fi
fi

